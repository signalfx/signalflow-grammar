#!/bin/sh

set -e

PARSER_GRAMMAR="grammar/SignalFlowV2Parser.g4"
LEXER_GRAMMAR="grammar/SignalFlowV2Lexer.g4"

function run_antlr() {
  local lang=$1;
  local antlr_lang=$2;
  local libdir=$3;
  local package=$4;
  local output=$5;
  local delpattern=${6:-*};

  echo "${lang}/"
  echo "  - generating sources from ${PARSER_GRAMMAR} and ${LEXER_GRAMMAR}..."
  ./generate_grammar.py ${LEXER_GRAMMAR} ${lang}
  mkdir -p ${libdir}
  rm -rf ${libdir}/${delpattern};
  antlr4 -Dlanguage=${antlr_lang} -visitor -lib ${libdir} -package ${package} \
   -o ${output} ${PARSER_GRAMMAR} ${LEXER_GRAMMAR}
  rm ${LEXER_GRAMMAR}
}

function do_java() {
  local version=$1

  run_antlr java Java java/src/main/java/com/signalfx/signalflow/grammar \
    com.signalfx.signalflow.grammar java/src/main/java/com/signalfx/signalflow

  echo "  - updating pom version to ${version}..."
  cd java
  mvn versions:set -DgenerateBackupPoms=false -DnewVersion=${version} > /dev/null
  mvn compile
  cd ..
}

function do_javascript() {
  local version=$1
  local bundle="signalflow-grammar-${version}.js"

  run_antlr javascript JavaScript javascript/lib/grammar \
    signalflow.grammar javascript/lib \
    com.signalfx.signalflow.grammar java/src/main/java/com/signalfx/signalflow

  echo "  - updating node.js package version to ${version}..."
  cd javascript
  npm version ${version} --allow-same-version > /dev/null

  echo "  - generating browserified bundle ${bundle}..."
  browserify index.js --standalone signalfx.signalflow -o ${bundle}
  cd ..
}

function do_python() {
  local version=$1

  run_antlr python Python2 python/signalflow/grammar \
    signalflow.grammar python/signalflow 'S*'

  echo "  - updating python package version to ${version}..."
  cd python
  sed -i "" -e "s/version='.*'/version='${version}'/" setup.py
  python setup.py build
  cd ..
}

if [ $# -ne 1 ] ; then
  echo >&2 "usage: $0 <new-version>"
  exit 1
fi

do_java $1
do_javascript $1
do_python $1

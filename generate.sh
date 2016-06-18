#!/bin/sh

set -e

GRAMMAR="grammar/SignalFlowV2.g4"

function do_java() {
  local version=$1

  echo "java/"
  echo "  - generating sources from ${GRAMMAR}..."
  antlr4 -Dlanguage=Java -visitor -package com.signalfx.signalflow.grammar \
    -o java/src/main/java/com/signalfx/signalflow ${GRAMMAR}

  echo "  - updating pom version to ${version}..."
  cd java
  mvn versions:set -DgenerateBackupPoms=false -DnewVersion=${version} > /dev/null
  cd ..
}

function do_javascript() {
  local version=$1
  local bundle="signalflow-grammar-${version}.js"

  echo "javascript/"
  echo "  - generating javascript sources from ${GRAMMAR}..."
  antlr4 -Dlanguage=JavaScript -visitor -package signalflow.grammar \
    -o javascript/lib ${GRAMMAR}

  echo "  - updating node.js package version to ${version}..."
  cd javascript
  npm version ${version} > /dev/null

  echo "  - generating browserified bundle ${bundle}..."
  browserify index.js --standalone signalfx.signalflow -o ${bundle}
  cd ..
}

function do_python() {
  local version=$1

  echo "python/"
  echo "  - generating python sources from ${GRAMMAR}..."
  antlr4 -Dlanguage=Python2 -visitor -package signalflow.grammar \
    -o python/signalflow ${GRAMMAR}

  echo "  - updating python package version to ${version}..."
  cd python
  sed -i "" -e "s/version='.*'/version='${version}'/" setup.py
  cd ..
}

if [ $# -ne 1 ] ; then
  echo >&2 "usage: $0 <new-version>"
  exit 1
fi

do_java $1
do_javascript $1
do_python $1

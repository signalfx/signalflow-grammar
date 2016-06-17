#!/bin/sh

set -x
set -e

antlr4 -Dlanguage=Java -visitor -package com.signalfx.signalflow.grammar -o java/src/main/java/com/signalfx/signalflow grammar/*.g4
antlr4 -Dlanguage=JavaScript -visitor -package signalflow.grammar -o javascript/lib grammar/*.g4
antlr4 -Dlanguage=Python2 -visitor -package signalflow.grammar -o python/signalflow grammar/*.g4

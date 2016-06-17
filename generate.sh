#!/bin/sh

set -x
set -e

antlr4 -Dlanguage=Java -package com.signalfx.signalflow.grammar -o java/src/main/java/com/signalfx/signalflow grammar/*.g4
antlr4 -Dlanguage=JavaScript -package signalflow.grammar -o javascript/lib grammar/*.g4
antlr4 -Dlanguage=Python2 -package signalflow.grammar -o python/signalflow grammar/*.g4

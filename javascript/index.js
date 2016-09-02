/**
 * Copyright (C) 2016 SignalFx, Inc. All rights reserved.
 */

var version = '2.0.0';
var antlr4 = require('antlr4/index');
var lexer = require('./lib/grammar/SignalFlowV2Lexer.js');
var parser = require('./lib/grammar/SignalFlowV2Parser.js');
var visitor = require('./lib/grammar/SignalFlowV2ParserVisitor.js');

module.exports = {
  version: version,
  antlr4: antlr4,
  lexer: lexer,
  parser: parser,
  visitor: visitor
}

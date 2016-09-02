/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
options { superClass=MySignalFlowV2Lexer; }

@header {
var SignalFlowV2Parser = require('./SignalFlowV2Parser.js').SignalFlowV2Parser;
function MySignalFlowV2Lexer(input) {
    antlr4.Lexer.call(this, input);
    this.tokens = [];
    this.indents = [];
    this.opened = 0;
    this.lastToken = null;
    return this;
};
MySignalFlowV2Lexer.prototype = Object.create(antlr4.Lexer.prototype);
MySignalFlowV2Lexer.prototype.constructor = MySignalFlowV2Lexer;
}

@members {
SignalFlowV2Lexer.prototype.emitToken = function(t) {
    this._token = t;
    this.tokens.push(t);
};

SignalFlowV2Lexer.prototype.nextToken = function() {
    // Check if the end-of-file is ahead and there are still some DEDENTS expected.
    if (this._input.LA(1) == SignalFlowV2Parser.EOF && this.indents.length > 0) {

        // Remove any trailing EOF tokens from our buffer.
        for (var i=this.tokens.length - 1; i >= 0; i--) {
          if (this.tokens[i].type == SignalFlowV2Parser.EOF) {
            this.tokens.splice(i, 1);
          }
        }
        // First emit an extra line break that serves as the end of the statement.
        this.emitToken(this.commonToken(SignalFlowV2Parser.NEWLINE, "\n"));

        // Now emit as many DEDENT tokens as needed.
        while (this.indents.length > 0) {
            this.emitToken(this.createDedent());
            this.indents.pop();
        }
        // Put the EOF back on the token stream.
        this.emitToken(this.commonToken(SignalFlowV2Parser.EOF, "<EOF>"));
    }
    next = antlr4.Lexer.prototype.nextToken.call(this);

    if (next.channel == antlr4.Token.DEFAULT_CHANNEL) {
        // Keep track of the last token on the default channel.
        this.lastToken = next;
    }

    return this.tokens.length == 0 ? next : this.tokens.shift();
};

SignalFlowV2Lexer.prototype.createDedent = function() {
    var dedent = this.commonToken(SignalFlowV2Parser.DEDENT, "");
    dedent.line = this.lastToken.line;
    return dedent;
};

SignalFlowV2Lexer.prototype.commonToken = function(type, text) {
    var stop = this.getCharIndex() - 1;
    var start = text.length == 0 ? stop : stop - text.length + 1;
    return new antlr4.CommonToken(this._tokenFactorySourcePair, type, this.DEFAULT_TOKEN_CHANNEL, start, stop);
 };

SignalFlowV2Lexer.prototype.getIndentationCount = function(spaces) {
    var count = 0;
    for (var idx = 0, len = spaces.length; idx < len; idx++) {
       var ch = spaces[idx];
       if ('\t' == ch) {
           count += 8 - (count % 8);
       } else {
           count += 1;
       }
    }
    return count;
};

SignalFlowV2Lexer.prototype.atStartOfInput = function() {
   return this.column == 0 && this.line == 1;
};
}

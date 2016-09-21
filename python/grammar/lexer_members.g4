/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
@lexer::header {
import re
from SignalFlowV2Parser import SignalFlowV2Parser
from antlr4.Token import CommonToken
}

@lexer::members {
    # A queue where extra tokens are pushed on (see the NEWLINE lexer rule).
    self.tokens = []

    # The stack that keeps track of the indentation level.
    self.indents = []

    # The amount of opened braces, brackets and parenthesis.
    self.opened = 0

    # The most recently produced token.
    self.lastToken = None

def emitToken(self, t):
    self._token = t
    self.tokens.append(t)

def nextToken(self):
    # Check if the end-of-file is ahead and there are still some DEDENTS expected.
    if self._input.LA(1) == SignalFlowV2Parser.EOF and self.indents:

        # Remove any trailing EOF tokens from our buffer.
        for i in range(len(self.tokens) -1, -1, -1):
            if (self.tokens[i].type == SignalFlowV2Parser.EOF):
                del self.tokens[i]

        # First emit an extra line break that serves as the end of the statement.
        self.emitToken(self.commonToken(SignalFlowV2Parser.NEWLINE, "\n"))

        # Now emit as many DEDENT tokens as needed.
        while self.indents:
            self.emitToken(self.createDedent());
            self.indents.pop()

        # Put the EOF back on the token stream.
        self.emitToken(self.commonToken(SignalFlowV2Parser.EOF, "<EOF>"))

    next = Lexer.nextToken(self)

    if next.channel == Token.DEFAULT_CHANNEL:
        # Keep track of the last token on the default channel.
        self.lastToken = next

    return next if not self.tokens else self.tokens.pop(0)

def createDedent(self):
    dedent = self.commonToken(SignalFlowV2Parser.DEDENT, "")
    dedent.line = self.lastToken.line
    return dedent

def commonToken(self, type, text):
    stop = self.getCharIndex() - 1
    start = stop if not text else stop - len(text) + 1
    return CommonToken(self._tokenFactorySourcePair, type, self.DEFAULT_TOKEN_CHANNEL, start, stop)

## Calculates the indentation of the provided whiteSpace, taking the
## following rules into account:
##
## "Tabs are replaced (from left to right) by one to eight spaces
##  such that the total number of characters up to and including
##  the replacement is a multiple of eight [...]"
##
##  -- https://docs.python.org/3.1/reference/lexical_analysis.html#indentation
@staticmethod
def getIndentationCount(whiteSpace):
    count = 0;
    for ch in whiteSpace:
        if '\t' == ch:
            count += 8 - (count % 8)
        else:
            count += 1
    return count

def atStartOfInput(self):
    return self.column == 0 and self.line == 1
}

/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
grammar SignalFlowV2;

program
  : interior_line* last_line
  ;

interior_line
  : statement? NEWLINE
  ;

last_line
  : statement? NEWLINE? EOF
  ;

statement
  : (ID BINDING)? test
  ;

test
  : or_test (IF or_test ELSE test)?
  | lambdef
  ;

lambdef
  : LAMBDA ID COLON test
  ;

or_test
  : and_test (OR and_test)*
  ;

and_test
  : not_test (AND not_test)*
  ;

not_test
  : NOT not_test
  | comparison
  ;

comparison
  : expr ((LT | LE | EQ | NE | GT | GE) expr)*
  ;

expr
  : term ((PLUS | MINUS) term)*
  ;

term
  : factor ((MUL | DIV) factor)*
  ;

factor
  : (PLUS | MINUS) factor
  | power
  ;

power
  : atom_expr (POW factor)?
  ;

atom_expr
  : atom trailer*
  ;

atom
  : list_value
  | LPAREN test RPAREN
  | ID
  | INT
  | FLOAT
  | STRING+
  | NONE
  | TRUE
  | FALSE
  | DURATION
  ;

list_value
  : LSQUARE (test (COMMA test)*)? RSQUARE
  ;

trailer
  : LPAREN actual_args? RPAREN
  | DOT ID
  ;

actual_args
  : argument (COMMA argument)*
  ;

argument
  : (ID BINDING)? test
  ;

LAMBDA
  : 'lambda'
  ;

NONE
  : 'None'
  ;

TRUE
  : 'True'
  ;

FALSE
  : 'False'
  ;

IF
  : 'if'
  ;

ELSE
  : 'else'
  ;

INT
  : '-'? [0-9]+
  ;


DURATION
  : [-+]?[0-9]+
    ('w' ([-+]?[0-9]+)?)?
    ('d' ([-+]?[0-9]+)?)?
    ('h' ([-+]?[0-9]+)?)?
    ('m' ([-+]?[0-9]+)?)?
    ('s' ([-+]?[0-9]+)?)?
    ('ms')?
  ;

FLOAT
  : '-'? [0-9]* '.'? [0-9]+ ([eE][+-]?[0-9]+)?
  ;

STRING
  : '\'' (ESCAPE_SEQ | ~( '\'' | '\\' | '\r' | '\n'))* '\''
  | '"' (ESCAPE_SEQ | ~( '"' | '\\' | '\r' | '\n'))* '"'
  ;

fragment
ESCAPE_SEQ
  : '\\' ([btnfr] | '\"' | '\'' | '\\' | [0-3][0-7][0-7] | [0-7][0-7] | [0-7])
  ;

LE
  : '<='
  ;

GE
  : '>='
  ;

EQ
  : '=='
  ;

NE
  : '!='
  ;

LT
  : '<'
  ;

GT
  : '>'
  ;

OR
  : 'or'
  ;

AND
  : 'and'
  ;

NOT
  : 'not'
  ;

ID
  : [a-zA-Z_][a-zA-Z0-9_]*
  ;

QMARK
  : '?'
  ;

EXCL
  : '!'
  ;

LPAREN
  : '('
  ;

RPAREN
  : ')'
  ;

LSQUARE
  : '['
  ;

RSQUARE
  : ']'
  ;

LBRACE
  : '{'
  ;

RBRACE
  : '}'
  ;

COMMA
  : ','
  ;

SEMICOLON
  : ';'
  ;

COLON
  : ':'
  ;

PLUS
  : '+'
  ;

MINUS
  : '-'
  ;

MUL
  : '*'
  ;

DIV
  : '/'
  ;

POW
  : '**'
  ;

BINDING
  : '='
  ;

DOT
  : '.'
  ;

NEWLINE
  : '\n'
  ;

WS
  : [ \t\r]+ -> skip
  ;

LINE_COMMENT
  : '#' ~[\r\n]* -> skip
  ;

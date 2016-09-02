/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
parser grammar SignalFlowV2Parser;

options { tokenVocab = SignalFlowV2Lexer; }
tokens { INDENT, DEDENT }

program
  : ( NEWLINE | statement )* EOF
  ;

functionDefinition
 : DEF ID parameters ':' suite
 ;

parameters
 : OPEN_PAREN varArgsList? CLOSE_PAREN
 ;

varArgsList
 : varArgsListParamDef ( ',' varArgsListParamDef )*
 ;

varArgsListParamDef
 : varArgsListParamName ( '=' test)?
 ;

varArgsListParamName
 : ID
 ;

statement
  : simpleStatement
  | compoundStatement
  ;

simpleStatement
  :  smallStatement ( ';' smallStatement )* ';'? NEWLINE?
  ;

smallStatement
  : exprStatement
  | returnStatement
  ;

exprStatement
  : (ID BINDING)? test
  ;

returnStatement
 : RETURN test?
 ;

flowStatment
 : returnStatement
 ;

compoundStatement
  : functionDefinition
  ;

suite
 : simpleStatement
 | NEWLINE INDENT statement+ DEDENT
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
  | OPEN_PAREN test CLOSE_PAREN
  | ID
  | INT
  | FLOAT
  | STRING+
  | NONE
  | TRUE
  | FALSE
  ;

list_value
  : LSQUARE (test (COMMA test)*)? RSQUARE
  ;

trailer
  : OPEN_PAREN actual_args? CLOSE_PAREN
  | DOT ID
  ;

actual_args
  : argument (COMMA argument)*
  ;

argument
  : (ID BINDING)? test
  ;


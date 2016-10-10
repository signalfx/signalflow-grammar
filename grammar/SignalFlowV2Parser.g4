/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
parser grammar SignalFlowV2Parser;

options { tokenVocab = SignalFlowV2Lexer; }
tokens { INDENT, DEDENT }

program
  : ( NEWLINE | statement )* EOF
  ;

eval_input
  : testlist NEWLINE* EOF
  ;

function_definition
  : DEF ID parameters ':' suite
  ;

parameters
  : OPEN_PAREN var_args_list? CLOSE_PAREN
  ;

var_args_list
  : var_args_list_param_def ( ',' var_args_list_param_def )*
  ;

var_args_list_param_def
  : var_args_list_param_name ( '=' test)?
  ;

var_args_list_param_name
  : ID
  ;

statement
  : simple_statement
  | compound_statement
  ;

simple_statement
  :  small_statement ( ';' small_statement )* ';'? (NEWLINE | EOF)
  ;

small_statement
  : expr_statement
  | flow_statement
  | import_statement
  ;

expr_statement
  : (id_list BINDING)? testlist
  ;

id_list
  : ID (',' ID)* ','?
  ;

import_statement
  : import_name
  | import_from
  ;

import_name
  : IMPORT dotted_as_names
  ;

import_from
  : FROM dotted_name
    IMPORT ( '*'
           | '(' import_as_names ')'
           | import_as_names
           )
  ;

import_as_name
  : ID ( AS ID )?
  ;

dotted_as_name
  : dotted_name ( AS ID )?
  ;

import_as_names
  : import_as_name ( ',' import_as_name )* ','?
  ;

dotted_as_names
  : dotted_as_name ( ',' dotted_as_name )*
  ;

dotted_name
  : ID ( '.' ID )*
  ;

return_statement
  : RETURN testlist?
  ;

flow_statement
  : return_statement
  ;

compound_statement
  : function_definition
  ;

suite
  : simple_statement
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
  | tuple_expr
  | ID
  | INT
  | FLOAT
  | STRING+
  | NONE
  | TRUE
  | FALSE
  ;

tuple_expr
  : OPEN_PAREN testlist? CLOSE_PAREN
  ;

testlist:
  test (COMMA test)* COMMA?
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


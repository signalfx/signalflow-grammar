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

decorator
  : '@' dotted_name ( '(' actual_args? ')' )? NEWLINE
  ;

decorators
  : decorator+
  ;

decorated
  : decorators function_definition
  ;

function_definition
  : DEF ID parameters ':' suite
  ;

parameters
  : OPEN_PAREN var_args_list? CLOSE_PAREN
  ;

var_args_list
  : var_args_list_param_def ( ',' var_args_list_param_def )* ( ','  ( (var_args_star_param (',' var_args_list_param_def)* (',' var_args_kws_param)?)
                                                                    | var_args_kws_param
                                                                    )?
                                                             )?
  | var_args_star_param (',' var_args_list_param_def)* (',' var_args_kws_param)?
  | var_args_kws_param
  ;

var_args_star_param
  :  STAR var_args_list_param_name?
  ;

var_args_kws_param
  : POWER var_args_list_param_name
  ;

var_args_list_param_def
  : var_args_list_param_name ( '=' test)?
  ;

var_args_list_param_name
  : ID param_type?
  ;

param_type
  : ':' ID
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
  | assert_statement
  ;

expr_statement
  : (id_list ASSIGN)? testlist
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
  : if_statement
  | function_definition
  | decorated
  ;

assert_statement
  : ASSERT test ( ',' test )?
  ;

if_statement
  : IF test ':' suite ( ELIF test ':' suite )* ( ELSE ':' suite )?
  ;

suite
  : simple_statement
  | NEWLINE INDENT statement+ DEDENT
  ;

test
  : or_test (IF or_test ELSE test)?
  | lambdef
  ;

// Backward compatibility cruft to support:
// [ x for x in lambda: True, lambda: False if x() ]
// even while also allowing:
// lambda x: 5 if x else 2
// (But not a mix of the two)
testlist_nocond
  : test_nocond ((COMMA test_nocond)+ (COMMA)?)?
  ;

test_nocond
  : or_test | lambdef_nocond
  ;

lambdef
  : LAMBDA ID COLON test
  ;

lambdef_nocond
  : LAMBDA ID COLON test_nocond
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
  : expr ((LESS_THAN | LT_EQ | EQUALS | NOT_EQ_1 | NOT_EQ_2 | GREATER_THAN | GT_EQ | IS | IS NOT) expr)*
  ;

expr
  : xor_expr ( '|' xor_expr )*
  ;

xor_expr
  :  and_expr ( '^' and_expr )*
  ;

and_expr
  : shift_expr ( '&' shift_expr )*
  ;

shift_expr
  : arith_expr ( '<<' arith_expr
               | '>>' arith_expr
               )*
  ;

arith_expr
  : term ((ADD | MINUS) term)*
  ;

term
  : factor ((STAR | DIV) factor)*
  ;

factor
  : (ADD | MINUS | NOT_OP) factor
  | power
  ;

power
  : atom_expr (POWER factor)?
  ;

atom_expr
  : atom trailer*
  ;

atom
  : list_expr
  | tuple_expr
  | dict_expr
  | ID
  | INT
  | FLOAT
  | STRING+
  | LONG_STRING+
  | NONE
  | TRUE
  | FALSE
  ;

trailer
  : OPEN_PAREN actual_args? CLOSE_PAREN
  | OPEN_BRACK subscript CLOSE_BRACK
  | DOT ID
  ;

subscript
  : test
  | test? COLON test?
  ;

list_expr
  : OPEN_BRACK list_maker? CLOSE_BRACK
  ;

list_maker
  : test ( list_for | (COMMA test)* (COMMA)? )
  ;

tuple_expr
  : OPEN_PAREN testlist_comp? CLOSE_PAREN
  ;

dict_expr
  : OPEN_BRACE (test ':' test ( ',' test ':' test )* ','?)? CLOSE_BRACE
  ;

testlist_comp
  : test (comp_for | (COMMA test)* COMMA?)
  ;

testlist
  : test (COMMA test)* COMMA?
  ;

actual_args
  : (argument COMMA)* ( argument COMMA?
                      | actual_star_arg (COMMA argument)* (COMMA actual_kws_arg)?
                      | actual_kws_arg
                      )
  ;

actual_star_arg
  :  STAR test
  ;

actual_kws_arg
  : POWER test
  ;

argument
  : test (comp_for)? | (ID ASSIGN)? test
  ;

list_iter
  : list_for | list_if
  ;

list_for
  : FOR id_list IN testlist_nocond (list_iter)?
  ;

list_if
  : IF test_nocond (list_iter)?
  ;

comp_iter
  : comp_for | comp_if
  ;

comp_for
  : FOR id_list IN or_test (comp_iter)?
  ;

comp_if
  : IF test_nocond (comp_iter)?
  ;

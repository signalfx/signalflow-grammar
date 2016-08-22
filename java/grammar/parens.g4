/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_PAREN
  : '(' {opened++;}
  ;

CLOSE_PAREN
  : ')' {opened--;}
  ;

/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_PAREN
  : '(' {this.opened += 1;}
  ;

CLOSE_PAREN
  : ')' {this.opened -= 1;}
  ;

/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_BRACK
  : '[' {this.opened += 1;}
  ;

CLOSE_BRACK
  : ']' {this.opened -= 1;}
  ;

/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_BRACE
  : '{' {this.opened += 1;}
  ;

CLOSE_BRACE
  : '}' {this.opened -= 1;}
  ;

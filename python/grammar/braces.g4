/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_BRACE
  : '{' {self.opened += 1}
  ;

CLOSE_BRACE
  : '}' {self.opened -= 1}
  ;

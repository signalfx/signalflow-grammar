/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_BRACK
  : '[' {self.opened += 1}
  ;

CLOSE_BRACK
  : ']' {self.opened -= 1}
  ;

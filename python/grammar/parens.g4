/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
OPEN_PAREN
  : '(' {self.opened += 1}
  ;

CLOSE_PAREN
  : ')' {self.opened -= 1}
  ;

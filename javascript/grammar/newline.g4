/**
 * Copyright (C) 2016 SignalFx, Inc.
 */
NEWLINE
 : ( {this.atStartOfInput()}?   SPACES
   | ( '\r'? '\n' | '\r' ) SPACES?
   )
   {
     var newLine = this.text.replace(/[^\r\n]+/g, "");
     var spaces = this.text.replace(/[\r\n]+/g, "");
     var next = this._input.LA(1);
     if (this.opened > 0 || next == '\r' || next == '\n' || next == '#') {
       // If we are inside a list or on a blank line, ignore all indents, 
       // dedents and line breaks.
       this.skip();
     } else {
       this.emitToken(this.commonToken(SignalFlowV2Lexer.NEWLINE, newLine));
       var indent = this.getIndentationCount(spaces);
       var previous = this.indents.length == 0 ? 0 : this.indents.slice(-1, 1);
       if (indent == previous) {
         // skip indents of the same size as the present indent-size
         this.skip();
       } else if (indent > previous) {
         this.indents.push(indent);
         this.emitToken(this.commonToken(SignalFlowV2Parser.INDENT, spaces));
       } else {
         // Possibly emit more than 1 DEDENT token.
         while (this.indents.length > 0 && this.indents.slice(-1, 1) > indent) {
           this.emitToken(this.createDedent());
           this.indents.pop();
         }
       }
     }
   }
 ;

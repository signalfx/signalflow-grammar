#!/usr/bin/env python

# Generates SignalFlowLexer.g4 file from template file and "include" files
import os
import sys

out_path = sys.argv[1]
lang = sys.argv[2]

with open(out_path + '.tmpl') as f:
    tmpl = f.read()
    for name, marker in [
        ('lexer_members.g4', '###LEXER_MEMBERS###'),
        ('newline.g4', '###NEWLINE###'),
        ('parens.g4', '###PARENS###')]:
        with open(os.path.join(lang, 'grammar', name)) as fragment:
            tmpl = tmpl.replace(marker, fragment.read())

with open(out_path, 'w') as f:
    f.write(tmpl)


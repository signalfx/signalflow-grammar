SignalFlow language grammar
===========================

This repository contains the SignalFx SignalFlow language grammar and the
structure and tools required to generate the public code artifacts that make
this grammar available in various languages.

The language is in ANTLR4 format and we use the `antlr` tool to generate the
corresponding source code for the target languages. From there, we can build
artifacts that can be included as dependencies in various projects that need to
parse SignalFlow programs.

**Note:** if you're looking to use the grammar, you should use one of the
generated artifacts instead of this repository.

Available languages
-------------------

Java
~~~~

The ``com.signalfx.public:signalflow-grammar`` artifact Jar is available on
Maven Central:

.. code:: xml

    <dependency>
      <groupId>com.signalfx.public</groupId>
      <artifactId>signalflow-grammar</artifactId>
      <version>1.0.0</version>
    </dependency>

Javascript
~~~~~~~~~~

The library is available for npm.js and Bower.

Python
~~~~~~

The library is available on PyPI and depends on the Python2 ANTLR runtime:

.. code::

    $ pip install signalflow-grammar

Then, from your code, you can do:

.. code:: python

    import antlr4
    from signalflow.grammar.SignalFlowV2Lexer import SignalFlowV2Lexer
    from signalflow.grammar.SignalFlowV2Parser import SignalFlowV2Parser

    def parse(program):
        lexer = SignalFlowV2Lexer(program)
        stream = antlr4.CommonTokenStream(lexer)
        parser = SignalFlowV2Parser(stream)
        ...

Generating or updating the artifacts
------------------------------------

Update the generated source code with the ``generate.sh`` script:

.. code::

    $ ./generate.sh
    + set -e
    + antlr4 -Dlanguage=Java -package com.signalfx.signalflow.grammar -o java/src/main/java/com/signalfx/signalflow grammar/SignalFlowV2.g4
    + antlr4 -Dlanguage=JavaScript -package signalflow.grammar -o javascript/lib grammar/SignalFlowV2.g4
    + antlr4 -Dlanguage=Python2 -package signalflow.grammar -o python/signalflow grammar/SignalFlowV2.g4

For each language, update the artifact version and perform a release in the
appropriate way.

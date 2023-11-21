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
      <version>2.14.0</version>
    </dependency>

Javascript
~~~~~~~~~~

The library is available for npm.js, and as a standalone browserified Javascript bundle.

Node.js
^^^^^^^

.. code::

    npm install -g signalflow-grammar.js

In browser
^^^^^^^^^^

.. code:: html

    <script type="text/javascript" src="https://s3.amazonaws.com/public-sites--signalfx-com/cdn/signalflow-grammar-2.7.0.js"></script>

Python
~~~~~~

The library is available on PyPI and depends on the Python2 ANTLR runtime:

.. code::

    $ pip install signalflow-grammar==2.7.0

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

Due to the Python like nature of SignalFlow some native code is
required to keep track of indent/dedent levels. This native code
is stored in <language>/grammar/*.g4. These native code files are
stitched into SignalFlowLexer.g4 by the generate_grammar.py script.

Update the generated source code with the ``generate.sh`` script:

.. code::

    $ ./generate.sh <version>
    $ git commit -a -m "Bump to version <version>"
    $ git push origin master

Then for each language, perform a release of the corresponding package.

Java
~~~~

.. code::

    $ cd java/
    $ mvn clean deploy -P release-sign-artifacts -DperformRelease=true -DrepositoryId=ossrh -Dgpg.useagent=false

Javascript
~~~~~~~~~~

.. code::

    $ cd javascript/
    $ npm publish
    $ aws s3 cp signalflow-grammar-<version>.js s3://public-sites--signalfx-com/cdn/

Python
~~~~~~

.. code::

    $ cd python/
    $ python setup.py bdist_wheel
    $ twine upload dist/signalflow_grammar-<version>-py2-none-any.whl

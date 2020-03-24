.. _testing:

Testing
=======

.. contents::
    :local:
    :depth: 1

Running tests
-------------

Run tests using `pytest`_.

.. code-block:: sh

   $ make pytest.all

Run tests by module using `pytest`_.

.. code-block:: sh

   $ make pytest run=campaign


Running tests Syntax
--------------------

Check lint code:

.. code-block:: sh

    $ make test.lint

Check sintax code:

.. code-block:: sh

    $ make test.syntax

.. _pytest: https://docs.pytest.org/en/latest/
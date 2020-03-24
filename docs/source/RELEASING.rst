.. _releasing:

Releasing
=========

.. contents::
    :local:
    :depth: 1

.. _testing:

Running tests
-------------

Run tests using `pytest`_.

.. code-block:: sh

   $ make test

Check sintax code:

.. code-block:: sh

    $ make test.lint

Bump a new version
------------------

Make a new version of dotfiles in the following steps:

* Make sure everything is commit to github.com.
* Update ``Changelog.rst`` with the next version.

.. code-block:: sh

    bumplus -v $VERSION

* Dry Run: ``bumpversion --dry-run --verbose --new-version 0.8.1 patch``
* Do it: ``bumpversion --new-version 0.8.1 patch``
* ... or: ``bumpversion --new-version 0.9.0 minor``
* Push it: ``git push --tags``

See the bumpversion_ documentation for details.

.. _bumpversion: https://pypi.org/project/bumpversion/
.. _pytest: https://docs.pytest.org/en/latest/

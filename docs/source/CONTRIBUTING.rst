How To Contribute
=================

.. contents::
   :local:

Contributions to dotfiles are welcome.

Getting Started
---------------

.. _commits:

Commits
^^^^^^^

Follow `semantic commits`_ to make :command:`git log` a little easier to follow.

chore
   something just needs to happen, e.g. versioning
docs
   documentation pages in :file:`_docs/` or docstrings
feat
   new code in :file:`src/`
fix
   code improvement in :file:`src/`
refactor
   code movement in :file:`src/`
style
   aesthetic changes
test
   test case modifications in :file:`test/`

Examples commit messages:

* (#01) chore: 0.1.0
* (#01) docs: Add configuration setting
* (#01) feat: Create Lambda function
* (#01) fix: Retry upload on failure
* (#01) refactor: Extract duplicate code
* (#01) style: isort, YAPF
* (#01) test: Coverage around add permissions

.. _semantic commits: https://seesparkbox.com/foundry/semantic_commit_messages

Branches
^^^^^^^^

Use `slash convention`_ with the same leaders as :ref:`commits`, e.g.:

* (prefix-task)

Documentation
^^^^^^^^^^^^^

* Use reStructuredText for docstrings and documentation
* For docstrings, follow :ref:`napoleon:example_google`
* For documentation pages, follow the strong guidelines from Python with
  :ref:`pythondev:documenting`

.. note::

   * Use :file:`.rst` for regular pages
   * Use :file:`.rest` for pages included using ``.. include:: file.rest``
     (fixes a Sphinx issue that thinks references are duplicated)

Testing
^^^^^^^

Run all unit tests

.. code-block:: bash

   make test.all

Run unit tests specified

.. code-block:: bash

   make test run={path}


Code Submission
---------------

Code Improvement
^^^^^^^^^^^^^^^^

#. See if an `Issue`_ exists

   * Comment with any added information to help the discussion

#. Create an `Issue`_ if needed

Code Submission
^^^^^^^^^^^^^^^

#. See if a `Pull Request`_ exists

   * Add some comments or review the code to help it along
   * Don't be afraid to comment when logic needs clarification

#. Create a Fork and open a `Pull Request`_ if needed

Code Review
^^^^^^^^^^^

* Anyone can review code
* Any `Pull Request`_ should be closed or merged within a week

Code Acceptance
^^^^^^^^^^^^^^^

Try to keep history as linear as possible using a `rebase` merge strategy.

#. One thumb up at minimum, two preferred
#. Request submitter to `rebase` and resolve all conflicts

   .. code:: bash

      # Update `develop`
      git checkout develop
      git pull origin develop

      # Update `#698` Branch
      git flow feature start #698
      git rebase develop

      # Update remote Branch and Pull Request
      git push -f

#. Merge the new feature

   .. code:: bash

      # Merge `#698` into `develop`
      git checkout develop
      git merge --ff-only feature/#698
      git push

#. Delete merged Branch

.. _Issue: https://github.com/luismayta/dotfiles/issues
.. _Pull Request: https://github.com/luismayta/dotfiles/pulls

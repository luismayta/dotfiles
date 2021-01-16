Dotfiles
========

|Build| |Code Climate| |Tag| |GitHub issues| |License| |Issue Count| |Test Coverage|

:Version: '1.7.1'
:Web: https://github.com/luismayta/dotfiles
:Download: http://github.com/luismayta/dotfiles
:Source: http://github.com/luismayta/dotfiles
:Keywords: dotfiles

.. contents:: Table of Contents:
    :local:

Introduction
------------



Installation
------------

dotfiles is installed by running one of the following commands in your
terminal. You can install this via the command-line with either ``curl``
or ``wget``.

Prerequisites
~~~~~~~~~~~~~

This is a list of applications that need to be installed previously to
enjoy all the goodies of this configuration.

-  `Curl <https://github.com/bagder/curl>`__
-  `Wget <http://www.gnu.org/software/wget>`__

via curl
~~~~~~~~

``bash -c "$(curl -fsSL https://rebrand.ly/github-6e7e4)"``

via wget
~~~~~~~~

``bash -c "$(wget https://rebrand.ly/github-6e7e4 -O -)"``

Resources
---------

`Asciinema <https://asciinema.org/>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Record and share your terminal sessions, the right way.

`Hunspell <https://github.com/hunspell/hunspell>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Hunspell is a spell checker and morphological analyzer library and
program designed for languages with rich morphology and complex word
compounding or character encoding.

Fonts
~~~~~

`Fonts <provision/fonts/>`__

+-----------------------------+--------------------+----------------------------+
| Powerline Font Family       | Formerly Known As  | License                    |
+=============================+====================+============================+
| Anonymice Powerline         | Anonymous Pro      | SIL Open Font License,     |
|                             |                    | Version 1.1                |
+-----------------------------+--------------------+----------------------------+
| DejaVu Sans Mono for        | DejaVu Sans Mono   | DejaVu Fonts License,      |
| Powerline                   |                    | Version 1.0                |
+-----------------------------+--------------------+----------------------------+
| Droid Sans Mono for         | Droid Sans Mono    | Apache License, Version    |
| Powerline                   |                    | 2.0                        |
+-----------------------------+--------------------+----------------------------+
| Droid Sans Mono Slashed for | Droid Sans Mono    | Apache License, Version    |
| Powerline                   | Slashed            | 2.0                        |
+-----------------------------+--------------------+----------------------------+
| Droid Sans Mono Dotted for  | Droid Sans Mono    | Apache License, Version    |
| Powerline                   | Dotted             | 2.0                        |
+-----------------------------+--------------------+----------------------------+
| Inconsolata for Powerline   | Inconsolata        | SIL Open Font License,     |
|                             |                    | Version 1.0                |
+-----------------------------+--------------------+----------------------------+
| Inconsolata-dz for          | Inconsolata-dz     | SIL Open Font License,     |
| Powerline                   |                    | Version 1.0                |
+-----------------------------+--------------------+----------------------------+
| Inconsolata-g for Powerline | Inconsolata-g      | SIL Open Font License,     |
|                             |                    | Version 1.0                |
+-----------------------------+--------------------+----------------------------+
| Literation Mono Powerline   | Liberation Mono    | SIL Open Font License,     |
|                             |                    | Version 1.1                |
+-----------------------------+--------------------+----------------------------+
| Meslo for Powerline         | Meslo              | Apache License, Version    |
|                             |                    | 2.0                        |
+-----------------------------+--------------------+----------------------------+
| Sauce Code Powerline        | Source Code Pro    | SIL Open Font License,     |
|                             |                    | Version 1.1                |
+-----------------------------+--------------------+----------------------------+
| Terminess Powerline         | Terminus           | SIL Open Font License,     |
|                             |                    | Version 1.1                |
+-----------------------------+--------------------+----------------------------+
| Ubuntu Mono derivative      | Ubuntu Mono        | Ubuntu Font License,       |
| Powerline                   |                    | Version 1.0                |
+-----------------------------+--------------------+----------------------------+
| Monofur for Powerline       | Monofur            | Freeware                   |
+-----------------------------+--------------------+----------------------------+
| Fura Powerline              | FiraMono           | SIL Open Font License,     |
|                             |                    | Version 1.1                |
+-----------------------------+--------------------+----------------------------+

Applications
------------

Git
~~~

`Git <http://git-scm.com/>`__

+-----------------+------------------------+-----------------+
| Configuration   | Description            | Do              |
+=================+========================+=================+
| gitconfig       | config alias git       | config git      |
+-----------------+------------------------+-----------------+
| gitignore       | ignore files globals   | ignored files   |
+-----------------+------------------------+-----------------+

.. code:: bash

        # Git credentials
        # Not in the repository, to prevent people from accidentally committing under my name
        GIT_AUTHOR_NAME="@slovacus"
        GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
        git config --global user.name "$GIT_AUTHOR_NAME"
        GIT_AUTHOR_EMAIL="slovacus@gmail.com"
        GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
        git config --global user.email "$GIT_AUTHOR_EMAIL"

Tmux
~~~~

`Tmux <https://tmux.github.io>`__ is a terminal multiplexer What is a
terminal multiplexer? It lets you switch easily between several programs
in one terminal, detach them (they keep running in the background) and
reattach them to a different terminal. And do a lot more.

*prefix:* ctrl + a

+------------+-------------------+-------------------------+
| Binding    | Call              | Do                      |
+============+===================+=========================+
| prefix     |                   | split-window -h         |
+------------+-------------------+-------------------------+
| prefix -   | split-window -v   | split window vertical   |
+------------+-------------------+-------------------------+

Tpm
~~~

`Tpm <https://github.com/tmux-plugins/tpm>`__ Tmux Plugin Manager

*Plugins*

+-----------------------------+---------------------------+-----------+
| Plugin                      | Decription                | Do        |
+=============================+===========================+===========+
| tmux-plugins/tmux-battery   | Show Battery Percentage   | Battery   |
+-----------------------------+---------------------------+-----------+
| tmux-plugins/tmux-cpu       | show Cpu Percentage       | Cpu       |
+-----------------------------+---------------------------+-----------+

Mac-cli
~~~~~~~

`Mac-Cli <https://github.com/guarinogabriel/mac-cli>`__ OS X command
line tools for developers

Nvm
~~~

`Nvm <https://github.com/creationix/nvm>`__ Node Version Manager

Rvm
~~~

`Rvm <https://rvm.io>`__ Ruby Version Manager

Antibody
~~~~~~~~

`Antibody <https://github.com/caarlos0/antibody>`__ A faster and simpler
antigen written in Golang.

Plugins
^^^^^^^

+------------------------------------------+--------------+
| Plugins                                  | Decription   |
+==========================================+==============+
| caarlos0/zsh-mkc                         |              |
+------------------------------------------+--------------+
| caarlos0/zsh-git-sync                    |              |
+------------------------------------------+--------------+
| zsh-users/zsh-completions                |              |
+------------------------------------------+--------------+
| zsh-users/zsh-syntax-highlighting        |              |
+------------------------------------------+--------------+
| zsh-users/zsh-history-substring-search   |              |
+------------------------------------------+--------------+
| mafredri/zsh-async                       |              |
+------------------------------------------+--------------+
| bobthecow/git-flow-completion            |              |
+------------------------------------------+--------------+
| luismayta/zsh-git-aliases                |              |
+------------------------------------------+--------------+
| luismayta/zsh-docker-compose-aliases     |              |
+------------------------------------------+--------------+
| luismayta/zsh-servers-functions          |              |
+------------------------------------------+--------------+
| Tarrasch/zsh-autoenv                     |              |
+------------------------------------------+--------------+
| Tarrasch/zsh-colors                      |              |
+------------------------------------------+--------------+
| chrissicool/zsh-256color                 |              |
+------------------------------------------+--------------+
| luismayta/zsh-goenv                      |              |
+------------------------------------------+--------------+
| wbinglee/zsh-wakatime                    |              |
+------------------------------------------+--------------+

Theme
^^^^^

+--------------------------+--------------+
| Plugins                  | Decription   |
+==========================+==============+
| marszall87/lambda-pure   |              |
+--------------------------+--------------+

Peco
~~~~

`Peco <https://github.com/peco/peco>`__ Simplistic interactive filtering
tool.

Tmux Themepack
~~~~~~~~~~~~~~

`Tmux Themepack <https://github.com/jimeh/tmux-themepack>`__ A pack of
various themes for Tmux.

**Wakatime Terminal:**

`zsh-wakatime <https://github.com/wbinglee/zsh-wakatime>`__


Support
-------

If you want to support this project, i only accept ``IOTA`` :p.

.. code-block:: bash

    Address: FTDCZELEMOQGL9MBWFZENJLFIZUBGMXLFVPRB9HTWYDYPTFKASJCEGJMSAXUWDQC9SJUDMZVIQKACQEEYPEUYLAMMD


Team
----

+---------------+
| |Luis Mayta|  |
+---------------+
| `luis mayta`_ |
+---------------+

License
-------

The MIT License (MIT). Please see `License File <LICENSE.rst>`__ for more
information.

Changelog
---------

Please see `CHANGELOG`_ for more information what
has changed recently.

Contributing
------------

Contributions are welcome!

Review the `CONTRIBUTING`_ for details on how to:

* Submit issues
* Submit pull requests


Contact Info
------------

Feel free to contact me to discuss any issues, questions, or comments.

* `Email`_
* `Twitter`_
* `GitHub`_
* `LinkedIn`_
* `Website`_
* `PGP`_

|linkedin| |beacon| |made|

Made with :coffee: and :pizza: by `luis mayta`_ and `hadenlabs`_.


.. Links
.. _`changelog`: CHANGELOG.rst
.. _`contributors`: docs/source/AUTHORS.rst
.. _`contributing`: docs/source/CONTRIBUTING.rst

.. _`hadenlabs`: https://github.com/hadenlabs
.. _`luis mayta`: https://github.com/luismayta


.. Team:
.. |Luis Mayta| image:: https://github.com/luismayta.png?size=100
   :target: https://github.com/luismayta

.. _`Github`: https://github.com/luismayta
.. _`Linkedin`: https://www.linkedin.com/in/luismayta
.. _`Email`: slovacus@gmail.com
    :target: mailto:slovacus@gmail.com
.. _`Twitter`: https://twitter.com/slovacus
.. _`Website`: http://luismayta.github.io
.. _`PGP`: https://keybase.io/luismayta/pgp_keys.asc

.. |Build| image:: https://travis-ci.org/luismayta/dotfiles.svg
   :target: https://travis-ci.org/luismayta/dotfiles
.. |Code Climate| image:: https://codeclimate.com/github/luismayta/dotfiles/badges/gpa.svg
   :target: https://codeclimate.com/github/luismayta/dotfiles
.. |Tag| image:: https://img.shields.io/github/tag/luismayta/dotfiles.svg?maxAge=2592000
   :target: https://github.com/luismayta/dotfiles
.. |GitHub issues| image:: https://img.shields.io/github/issues/luismayta/dotfiles.svg
   :target: https://github.com/luismayta/dotfiles/issues
.. |License| image:: https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square
   :target: LICENSE
.. |Issue Count| image:: https://codeclimate.com/github/luismayta/dotfiles/badges/issue_count.svg
   :target: https://codeclimate.com/github/luismayta/dotfiles
.. |Test Coverage| image:: https://codeclimate.com/github/luismayta/dotfiles/badges/coverage.svg
   :target: https://codeclimate.com/github/luismayta/dotfiles/coverage
.. Footer:
.. |linkedin| image:: http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png
   :target: http://pe.linkedin.com/in/luismayta
.. |beacon| image:: https://ga-beacon.appspot.com/UA-65019326-1/github.com/luismayta/dotfiles/readme
   :target: https://github.com/luismayta/dotfiles
.. |made| image:: https://img.shields.io/badge/Made%20with-Zsh-1f425f.svg
   :target: http://www.zsh.org

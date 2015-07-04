[![Stories in Ready](https://badge.waffle.io/luismayta/dotfiles.svg?label=ready&title=Ready)](http://waffle.io/luismayta/dotfiles)

[![GitHub stars](https://img.shields.io/github/stars/badges/shields.svg)](https://github.com/luismayta/dotfiles)

## Overview

#### Supported Architectures

### Prerequisites

__Disclaimer:__ _dotfiles works best on Mac OS X and Linux._

    * Unix-based operating system (Mac OS X or Linux)
    * [Zsh](http://www.zsh.org) should be installed (v4.3.9 or more recent). If not pre-installed (`zsh --version` to confirm)
    * `curl` or `wget` should be installed
    * `git` should be installed
    * `tmux` should be installed

### Basic Installation

dotfiles is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

`sh -c "$(curl -fsSL https://raw.github.com/luismayta/dotfiles/master/install.sh)"`

#### via wget

`sh -c "$(wget https://raw.github.com/luismayta/dotfiles/master/install.sh -O -)"`

```bash
    # Git credentials
    # Not in the repository, to prevent people from accidentally committing under my name
    GIT_AUTHOR_NAME="@slovacus"
    GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
    git config --global user.name "$GIT_AUTHOR_NAME"
    GIT_AUTHOR_EMAIL="slovacus@gmail.com"
    GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
    git config --global user.email "$GIT_AUTHOR_EMAIL"
```

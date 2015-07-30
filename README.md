# Dotfiles

<span class="badges" align="center">
[![Build Status](https://travis-ci.org/luismayta/dotfiles.svg)](https://travis-ci.org/luismayta/dotfiles)
[![Stories in Ready](https://badge.waffle.io/luismayta/dotfiles.svg?label=ready&title=Ready)](http://waffle.io/luismayta/dotfiles)
[![GitHub issues](https://img.shields.io/github/issues/luismayta/dotfiles.svg)](https://github.com/luismayta/dotfiles/issues)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square)](LICENSE)
</span>

## Introduction

## Help/Support

## Usage

- [CHANGELOG](CHANGELOG.md)
- [CONTRIBUTING](CONTRIBUTING.md)

## Change log

Please see [CHANGELOG](CHANGELOG.md) for more information what has changed recently.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

## Credits

- [Luis Mayta][link-author]
- [All Contributors][link-contributors]

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.

## Installation

dotfiles is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

### Prerequisites

This is a list of applications that need to be installed previously to enjoy all the goodies of this configuration.

* [Git](http://git-scm.com)
* [Zsh](http://www.zsh.org)
* [Curl](https://github.com/bagder/curl)
* [Wget](http://www.gnu.org/software/wget)
* [Tmux](https://tmux.github.io)

### via curl

`sh -c "$(curl -fsSL https://raw.github.com/luismayta/dotfiles/master/install.sh)"`

### via wget

`sh -c "$(wget https://raw.github.com/luismayta/dotfiles/master/install.sh -O -)"`

### Git

[Git](http://git-scm.com/)

| Configuration  | Descriptin           | Do           |
| -------------- |:--------------------:| ------------:|
| gitconfig      | config alias git     | config git   |
| gitignore      | ignore files globals | ignored files|

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

### Tmux

[Tmux](https://tmux.github.io) is a terminal multiplexer
What is a terminal multiplexer? It lets you switch easily between several
programs in one terminal, detach them (they keep running in the background)
and reattach them to a different terminal. And do a lot more.

*prefix:* ctrl + a

| Binding        | Call                 | Do                      |
| -------------- |:--------------------:| -----------------------:|
| prefix |       | split-window -h      | split window horizontal |
| prefix -       | split-window -v      | split window vertical   |

### Tpm

[Tpm](https://github.com/tmux-plugins/tpm) Tmux Plugin Manager

*Plugins*

| Plugin                    | Decription              | Do           |
| ------------------------- |:-----------------------:| ------------:|
| tmux-plugins/tmux-battery | Show Battery Percentage | Battery      |
| tmux-plugins/tmux-cpu     | show Cpu Percentage     | Cpu          |

### Nvm

[Nvm](https://github.com/creationix/nvm) Node Version Manager

### Rvm

[Rvm](https://rvm.io) Ruby Version Manager

<span class="badges">
[![](http://api.coderwall.com/luismayta/endorsecount.png)](http://coderwall.com/luismayta)
[![](http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png)](http://pe.linkedin.com/in/luismayta)
[![](https://ga-beacon.appspot.com/UA-65019326-1/dotfiles/readme)](https://github.com/luismayta/dotfiles)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/luismayta/dotfiles/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
</span>

[link-author]: https://github.com/luismayta
[link-contributors]: contributors

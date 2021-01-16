# Dotfiles

[![Build](https://travis-ci.org/luismayta/dotfiles.svg)](https://travis-ci.org/luismayta/dotfiles) [![Code
Climate](https://codeclimate.com/github/luismayta/dotfiles/badges/gpa.svg)](https://codeclimate.com/github/luismayta/dotfiles) [![Tag](https://img.shields.io/github/tag/luismayta/dotfiles.svg?maxAge=2592000)](https://github.com/luismayta/dotfiles) [![GitHub
issues](https://img.shields.io/github/issues/luismayta/dotfiles.svg)](https://github.com/luismayta/dotfiles/issues) [![License](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square)](LICENSE) [![Issue
Count](https://codeclimate.com/github/luismayta/dotfiles/badges/issue_count.svg)](https://codeclimate.com/github/luismayta/dotfiles) [![Test
Coverage](https://codeclimate.com/github/luismayta/dotfiles/badges/coverage.svg)](https://codeclimate.com/github/luismayta/dotfiles/coverage)

## Introduction

## Installation

dotfiles is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

### Prerequisites

This is a list of applications that need to be installed previously to enjoy all the goodies of this configuration.

- [Curl](https://github.com/bagder/curl)
- [Wget](http://www.gnu.org/software/wget)

### via curl

`bash -c "$(curl -fsSL https://rebrand.ly/73aaa2n)"`

### via wget

`bash -c "$(wget https://rebrand.ly/73aaa2n -O -)"`

## Resources

### [Asciinema](https://asciinema.org/)

Record and share your terminal sessions, the right way.

### [Hunspell](https://github.com/hunspell/hunspell)

Hunspell is a spell checker and morphological analyzer library and program designed for languages with rich morphology and complex word compounding or character encoding.

### Fonts

[Fonts](provision/fonts/)

---

Powerline Font Family Formerly Known As License

---

Anonymice Powerline Anonymous Pro SIL Open Font License, Version 1.1

DejaVu Sans Mono for DejaVu Sans Mono DejaVu Fonts License, Powerline Version 1.0

Droid Sans Mono for Droid Sans Mono Apache License, Version Powerline 2.0

Droid Sans Mono Slashed for Droid Sans Mono Apache License, Version Powerline Slashed 2.0

Droid Sans Mono Dotted for Droid Sans Mono Apache License, Version Powerline Dotted 2.0

Inconsolata for Powerline Inconsolata SIL Open Font License, Version 1.0

Inconsolata-dz for Inconsolata-dz SIL Open Font License, Powerline Version 1.0

Inconsolata-g for Powerline Inconsolata-g SIL Open Font License, Version 1.0

Literation Mono Powerline Liberation Mono SIL Open Font License, Version 1.1

Meslo for Powerline Meslo Apache License, Version 2.0

Sauce Code Powerline Source Code Pro SIL Open Font License, Version 1.1

Terminess Powerline Terminus SIL Open Font License, Version 1.1

Ubuntu Mono derivative Ubuntu Mono Ubuntu Font License, Powerline Version 1.0

Monofur for Powerline Monofur Freeware

Fura Powerline FiraMono SIL Open Font License, Version 1.1

---

## Applications

### Git

[Git](http://git-scm.com/)

Configuration Description Do

---

gitconfig config alias git config git gitignore ignore files globals ignored files

```{.sourceCode .bash}
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

[Tmux](https://tmux.github.io) is a terminal multiplexer What is a terminal multiplexer? It lets you switch easily between several programs in one terminal, detach them (they keep running in the background) and reattach them to a different terminal. And do a lot more.

_prefix:_ ctrl + a

Binding Call Do

---

prefix split-window -h prefix - split-window -v split window vertical

### Tpm

[Tpm](https://github.com/tmux-plugins/tpm) Tmux Plugin Manager

_Plugins_

Plugin Decription Do

---

tmux-plugins/tmux-battery Show Battery Percentage Battery tmux-plugins/tmux-cpu show Cpu Percentage Cpu

### Mac-cli

[Mac-Cli](https://github.com/guarinogabriel/mac-cli) OS X command line tools for developers

### Nvm

[Nvm](https://github.com/creationix/nvm) Node Version Manager

### Rvm

[Rvm](https://rvm.io) Ruby Version Manager

### Antibody

[Antibody](https://github.com/caarlos0/antibody) A faster and simpler antigen written in Golang.

#### Plugins

Plugins Decription

---

caarlos0/zsh-mkc
 caarlos0/zsh-git-sync
 zsh-users/zsh-completions
 zsh-users/zsh-syntax-highlighting
 zsh-users/zsh-history-substring-search
 bobthecow/git-flow-completion
 luismayta/zsh-git-aliases
 luismayta/zsh-docker-compose-aliases
 luismayta/zsh-servers-functions
 Tarrasch/zsh-autoenv
 Tarrasch/zsh-colors
 chrissicool/zsh-256color
 luismayta/zsh-goenv
 wbinglee/zsh-wakatime

### Tmux Themepack

[Tmux Themepack](https://github.com/jimeh/tmux-themepack) A pack of various themes for Tmux.

**Wakatime Terminal:**

[zsh-wakatime](https://github.com/wbinglee/zsh-wakatime)

## Support

If you want to support this project, i only accept `IOTA` :p.

```{.sourceCode .bash}
Address: FTDCZELEMOQGL9MBWFZENJLFIZUBGMXLFVPRB9HTWYDYPTFKASJCEGJMSAXUWDQC9SJUDMZVIQKACQEEYPEUYLAMMD
```

## Team

---

[luis mayta](https://github.com/luismayta)

---

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information what has changed recently.

## Contributing

Contributions are welcome!

Review the [CONTRIBUTING]() for details on how to:

- Submit issues
- Submit pull requests

## Contact Info

Feel free to contact me to discuss any issues, questions, or comments.

- [Email](slovacus@gmail.com:target:%20mailto:slovacus@gmail.com)
- [Twitter](https://twitter.com/slovacus)
- [GitHub](https://github.com/luismayta)
- [LinkedIn](https://pe.linkedin.com/in/luismayta)
- [Website](https://luismayta.github.io)
- [PGP](https://keybase.io/luismayta/pgp_keys.asc)

Made with :coffee: and :pizza: by [Luis Mayta](https://github.com/luismayta) and [equipindustry](https://github.com/equipindustry).

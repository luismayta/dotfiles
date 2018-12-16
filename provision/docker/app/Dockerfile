FROM luismayta/ubuntu-dotfiles

MAINTAINER Luis Mayta <@slovacus>

ARG home

LABEL NAME ubuntu-dotfiles
LABEL VERSION latest

# Set environment variables.
ENV HOME $home
ENV SRC_PATH $HOME/.dotfiles

# Define working directory.
WORKDIR $SRC_PATH

CMD ["zsh"]

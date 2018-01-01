FROM luismayta/ubuntu-dotfiles:latest

MAINTAINER Luis Mayta <@slovacus>

LABEL NAME ubuntu-dotfiles
LABEL VERSION latest

# Set environment variables.
ENV HOME /usr/src
ENV SRC_PATH "${HOME}"/.dotfiles

# Define working directory.
WORKDIR "${SRC_PATH}"

CMD ["zsh"]

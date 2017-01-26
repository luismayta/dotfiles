FROM luismayta/ubuntu-dotfiles:latest
MAINTAINER Luis Mayta <@slovacus>

# Install.
RUN \
  apt-get install -y zsh

# Set environment variables.
ENV HOME /docker

# Define working directory.
WORKDIR /docker/.dotfiles

# Define default command.
CMD ["zsh"]

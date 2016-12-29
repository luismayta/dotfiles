FROM ubuntu:14.04

# Install.
ONBUILD RUN \
  apt-get update && \
  locale-gen en_US.UTF-8 && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y tmux curl git man unzip vim wget zsh

# Set environment variables.
ENV HOME /docker/.dotfiles

# Define working directory.
WORKDIR /docker/.dotfiles

# Define default command.
CMD ["bash"]

FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD docker/.bashrc /root/.bashrc
ADD docker/.gitconfig /root/.gitconfig
ADD docker/.scripts /root/.scripts

# Set environment variables.
ENV HOME /docker

# Define working directory.
WORKDIR /docker

# Define default command.
CMD ["bash"]

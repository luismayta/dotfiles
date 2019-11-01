FROM python:3.7.3-slim

MAINTAINER Luis Mayta <@slovacus>

ARG stage
LABEL NAME dotfiles-check-$stage

COPY Pipfile* /usr/src/

# set working directory to /usr/src/
WORKDIR /usr/src/

RUN apt-get update -y \
  && apt-get -y install --no-install-recommends \
  # tools validation
  git-core \
  shellcheck \
  # install python dependencies
  && pip3 install pipenv \
  && pipenv install --dev --skip-lock \
  && pipenv shell --fancy \
  && apt-get purge \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

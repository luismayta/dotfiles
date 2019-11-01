FROM luismayta/ubuntu-dotfiles

MAINTAINER Luis Mayta <@slovacus>

ARG home

LABEL NAME ubuntu-dotfiles
LABEL VERSION latest

# Set environment variables.
ENV HOME $home
ENV SRC_PATH $HOME/.dotfiles

ENV PACKAGES bash \
  git \
  gcc \
  libc-dev \
  make \
  musl-dev \
  openssl \
  gcc \
  libgdal20 \
  libev-dev

COPY Pipfile* /usr/src/

# set working directory to /usr/src/
WORKDIR /usr/src/

RUN  groupadd -g 500 -r python \
  && groupadd developer \
  && useradd -m -g developer -G python developer \
  && chown -R developer:python /usr/local/bin \
  && mkdir -p /usr/src \
  && chown -R developer /usr/src \

# install packages
  && apt-get update -y \
  && apt-get install -y ${PACKAGES} --no-install-recommends \
  && apt-get clean \
  && apt-get autoremove \

  && pip3 install pipenv \
  && pipenv install --dev --skip-lock \
  && pipenv shell --fancy \
  && apt-get purge \
  && rm -rf /var/lib/apt/lists/*


CMD ["zsh"]

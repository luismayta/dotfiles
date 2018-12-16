FROM python:3.6.4

MAINTAINER Luis Mayta <@slovacus>

LABEL NAME ubuntu-dotfiles
LABEL VERSION latest

COPY ./requirements/ /usr/src/requirements/
COPY ./requirements.txt /usr/src/requirements.txt

WORKDIR /usr/src/

# install python dependencies
RUN pip install -r /usr/src/requirements/test.txt

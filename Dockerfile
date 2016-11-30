FROM johnpryan/dart-content-shell-docker

MAINTAINER brian@brianegan.com

RUN apt-get update
RUN apt-get install -y lcov git-core libglu1

WORKDIR /
RUN git clone https://github.com/flutter/flutter.git
RUN /flutter/bin/flutter

ENV PATH $PATH:/usr/lib/dart/bin:/flutter/bin

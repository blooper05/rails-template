FROM ruby:3.1.2-alpine3.16

ENV BUNDLE_AUTO_INSTALL=true \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/bundle \
  BUNDLE_RETRY=3

WORKDIR /usr/src/app

RUN apk add --update --no-cache \
  # for native extensions
  build-base=0.5-r3 \
  # for pg
  postgresql14-dev=14.5-r0 \
  # for activesupport
  tzdata=2022c-r0 \
  # for rails-erd
  graphviz=3.0.0-r0 \
  ttf-freefont=20120503-r2 \
  # development tools
  less=590-r0 \
  && gem install bundler --version=2.3.21

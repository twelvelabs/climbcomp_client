FROM ruby:2.5.1-alpine

RUN apk add --update \
  bash \
  build-base \
  curl \
  && rm -rf /var/cache/apk/*

RUN mkdir /climbcomp
WORKDIR /climbcomp

COPY *.gemspec /climbcomp/
COPY Gemfile* /climbcomp/
RUN bundle install --jobs 4

COPY . /climbcomp

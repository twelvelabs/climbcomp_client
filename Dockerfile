FROM ruby:2.5.1-alpine

RUN apk add --update \
  bash \
  build-base \
  curl \
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY *.gemspec /app/
COPY Gemfile* /app/
RUN bundle install --jobs 4

COPY . /app

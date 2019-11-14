FROM ruby:2.6.5-alpine

RUN apk add --update --no-cache \
  build-base \
  postgresql-dev \
  imagemagick \
  nodejs \
  yarn \
  tzdata \
  postgresql-client \
  graphviz \
  imagemagick \
  tzdata \
  file

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

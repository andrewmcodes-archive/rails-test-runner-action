FROM node:13-slim as node
FROM ruby:2.6.5-slim

LABEL "maintainer"="Andrew Mason <andrewmcodes@protonmail.com>"
RUN printenv
########################################
# Set Environment variables
########################################
ARG RAILS_ENV="test"
ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/bin"
ENV APP_HOME=$GITHUB_WORKSPACE \
  RAILS_ENV=$RAILS_ENV \
  MALLOC_ARENA_MAX=2

########################################
# Basic application requirements
# => Update all packages before install required packages
# => Install essential header libraries
########################################
RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends apt-utils && \
  apt-get upgrade -y && apt-get -qq dist-upgrade && \
  apt-get install -qq -y build-essential apt-transport-https ca-certificates curl && \
  apt-get install -qq -y git graphviz imagemagick libpq-dev netcat postgresql-client postgresql-contrib && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -qq -y yarn && \
  apt autoremove -y -qq && apt-get clean && rm -rf /var/lib/apt/lists/*

########################################
# NODE (required for numerous Rails gems)
########################################
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /opt/yarn-* /opt/yarn
RUN ln -s /opt/yarn/yarn-*/bin/yarn /usr/local/bin/yarn && \
  ln -s /opt/yarn/yarn-*/bin/yarnpkg /usr/local/bin/yarnpkg && \
  mkdir -p /tmp/src /opt

########################################
# APP Directory and Bundler
########################################
RUN mkdir -p $APP_HOME && \
  gem update --system && \
  gem install bundler --no-document && gem install rake --no-document
WORKDIR $APP_HOME

########################################
# Application / Install gems
########################################
COPY . $APP_HOME

ENV BUNDLE_PATH="vendor/cache"

RUN set -ex && bundle check || bundle install --jobs $(nproc) --retry=3 --quiet
# Install and compile the applications assets
RUN yarn check || yarn install --frozen-lockfile; \
  yarn cache clean

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

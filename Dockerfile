FROM node:13-slim as node
FROM ruby:2.6.5-slim

LABEL "maintainer"="Andrew Mason <andrewmcodes@protonmail.com>"
ENV DEBIAN_FRONTEND noninteractive

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

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

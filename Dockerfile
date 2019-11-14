FROM ruby:2.6.5

ENV BUNDLE_PATH="/github/workspace/vendor/bundle"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  cmake \
  graphviz \
  imagemagick \
  libpq-dev \
  libssl-dev --fix-missing --no-install-recommends \
  nodejs \
  postgresql-client \
  postgresql-contrib \
  yarn \
  lsof

RUN node -v
RUN yarn -v
RUN ruby -v

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN gem update --system
RUN gem install bundler -v "2.0.2"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

# FROM ruby:2.6.5-slim

# ENV BUNDLE_PATH="/github/workspace/vendor/bundle"

# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# RUN apt-get update -qq && apt-get install -y \
#   build-essential \
#   cmake \
#   graphviz \
#   imagemagick \
#   libpq-dev \
#   libssl-dev --fix-missing --no-install-recommends \
#   nodejs \
#   postgresql-client \
#   postgresql-contrib \
#   yarn

# RUN node -v
# RUN yarn -v
# RUN ruby -v

# RUN gem update --system
# RUN gem install bundler -v "2.0.2"

# COPY "entrypoint.sh" "/entrypoint.sh"
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["help"]

# RUN apt-get update && \
#   apt-get install -qq -y --no-install-recommends apt-utils && \
#   apt-get upgrade -y && apt-get -qq dist-upgrade && \
#   apt-get install -qq -y build-essential apt-transport-https ca-certificates curl && \
#   apt-get install -qq -y git graphviz imagemagick libpq-dev netcat postgresql-client postgresql-contrib && \
#   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#   apt-get update -qq && apt-get install -qq -y yarn && \
#   apt autoremove -y -qq && apt-get clean && rm -rf /var/lib/apt/lists/*

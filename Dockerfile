FROM ruby:2.6.5

ENV BUNDLE_PATH="/github/workspace/vendor/bundle"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libssl-dev --fix-missing --no-install-recommends \
  postgresql-client \
  cmake \
  imagemagick \
  graphviz \
  postgresql-contrib \
  libpq-dev \
  nodejs \
  yarn

RUN node -v
RUN yarn -v
RUN ruby -v

RUN gem update --system
RUN gem install bundler -v "2.0.2"

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

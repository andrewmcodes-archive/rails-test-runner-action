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
  yarn

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN curl https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -o /tmp/chromedriver
RUN unzip -o /tmp/chromedriver
RUN chmod +x /tmp/chromedriver
COPY /tmp/chromedriver /usr/local/bin/

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN gem update --system
RUN gem install bundler -v "2.0.2"
RUN gem install rake -v "13.0.1"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

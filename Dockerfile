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
  curl \
  yarn

# Install Chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -o /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver
RUN unzip /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN gem update --system
RUN gem install bundler -v "2.0.2"
RUN gem install rake -v "13.0.1"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

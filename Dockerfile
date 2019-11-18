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
  openjdk-11-jre \
  openjdk-11-jre-headless \
  openjdk-11-jdk \
  openjdk-11-jdk-headless \
  libgconf-2-4 \
  nodejs \
  postgresql-client \
  postgresql-contrib \
  yarn

RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && (sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb || sudo apt-get -fy install)  \
  && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
  && sudo sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
  "/opt/google/chrome/google-chrome" \
  && google-chrome --version

RUN CHROME_VERSION="$(google-chrome --version)" \
  && export CHROMEDRIVER_RELEASE="$(echo $CHROME_VERSION | sed 's/^Google Chrome //')" && export CHROMEDRIVER_RELEASE=${CHROMEDRIVER_RELEASE%%.*} \
  && CHROMEDRIVER_VERSION=$(curl --silent --show-error --location --fail --retry 4 --retry-delay 5 http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_RELEASE}) \
  && curl --silent --show-error --location --fail --retry 4 --retry-delay 5 --output /tmp/chromedriver_linux64.zip "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
  && cd /tmp \
  && unzip chromedriver_linux64.zip \
  && rm -rf chromedriver_linux64.zip \
  && sudo mv chromedriver /usr/local/bin/chromedriver \
  && sudo chmod +x /usr/local/bin/chromedriver \
  && chromedriver --version


COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN gem update --system
RUN gem install bundler -v "2.0.2"
RUN gem install rake -v "13.0.1"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

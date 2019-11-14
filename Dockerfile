FROM ruby:2.6.5
ENV BUNDLE_PATH="/github/workspace/vendor/bundle"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn

RUN gem update --system
RUN gem install bundler -v "2.0.1"

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

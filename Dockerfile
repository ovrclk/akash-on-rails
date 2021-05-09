FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y yarn postgresql-client

ENV BUNDLER_VERSION 2.2.15
RUN gem update --system --quiet && gem install bundler -v "$BUNDLER_VERSION"

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY package.json yarn.lock ./

RUN yarn install

COPY . ./

RUN chmod +x entrypoint.sh

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

ENTRYPOINT ["./entrypoint.sh"]

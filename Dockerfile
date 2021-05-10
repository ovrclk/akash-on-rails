FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && apt-get install -y curl zip yarn postgresql-client-12 imagemagick

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/bin

COPY ./scripts/run-app.sh scripts/run-app.sh
COPY ./scripts/restore-postgres.sh scripts/restore-postgres.sh
RUN chmod +x scripts/run-app.sh scripts/restore-postgres.sh

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

CMD ["/scripts/run-app.sh"]

ENTRYPOINT ["./entrypoint.sh"]

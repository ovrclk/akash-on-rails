FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && apt-get install -y zip yarn postgresql-client-12 imagemagick cron

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/bin

ENV BUNDLER_VERSION 2.2.15
RUN gem update --system --quiet && gem install bundler -v "$BUNDLER_VERSION"

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh entrypoint.sh

ENV POSTGRES_HOST=postgres
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]

ARG CONTEXT=app
ENV CONTEXT=${CONTEXT}
CMD /scripts/run-${CONTEXT}.sh

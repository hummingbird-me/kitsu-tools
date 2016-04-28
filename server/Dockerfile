FROM rails:4.2
MAINTAINER Hummingbird Media, Inc.

RUN mkdir -p /opt/hummingbird/server

# Preinstall gems in an earlier layer so we don't reinstall every time any file
# changes.
COPY ./Gemfile /opt/hummingbird/server/
COPY ./Gemfile.lock /opt/hummingbird/server/
WORKDIR /opt/hummingbird/server
RUN bundle install

# *NOW* we copy the codebase in
COPY . /opt/hummingbird/server

ENV DATABASE_URL=postgresql://postgres:mysecretpassword@postgres/
ENV REDIS_URL=redis://redis/1
ENV ELASTICSEARCH_HOST=elasticsearch

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

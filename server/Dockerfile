FROM rails:4.2
MAINTAINER Hummingbird Media, Inc.

RUN mkdir -p /opt/hummingbird/server
COPY . /opt/hummingbird/server

WORKDIR /opt/hummingbird/server
RUN bundle install
ENV DATABASE_URL=postgresql://postgres:mysecretpassword@postgres/
ENV REDIS_URL=redis://redis/1

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port=80"]
EXPOSE 80

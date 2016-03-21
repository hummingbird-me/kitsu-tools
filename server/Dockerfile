FROM rails:4.2
MAINTAINER Hummingbird Media, Inc.

RUN mkdir -p /opt/hummingbird/server
COPY . /opt/hummingbird/server

WORKDIR /opt/hummingbird/server
RUN bundle install

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "--port 80"]
EXPOSE 80

FROM phusion/baseimage
MAINTAINER Hummingbird Media, Inc.

# Dependencies: PG client
RUN apt-get update && \
    apt-get install -y curl git postgresql-contrib libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# RVM
RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable --ruby=2.2.3

# Hummingbird
WORKDIR /opt/hummingbird

COPY Gemfile /opt/hummingbird/
COPY Gemfile.lock /opt/hummingbird/

RUN bash -c "source /usr/local/rvm/scripts/rvm && \ 
    gem install bundler && \
    bundle install"

COPY . /opt/hummingbird

EXPOSE 3000
ENTRYPOINT ["/opt/hummingbird/bin/entrypoint.sh"]
CMD ["bundle", "exec", "foreman", "start", "--env=.env,.dockerenv"]

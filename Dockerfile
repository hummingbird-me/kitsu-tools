FROM ubuntu

MAINTAINER Hummingbird Media, Inc.

# Dependencies: RVM, PG client
RUN apt-get update && \
    apt-get install -y curl git postgresql-contrib libpq-dev npm nodejs && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    rm -rf /var/lib/apt/lists/*

RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable --ruby=2.1.3

RUN npm install -g ember-cli bower

# Hummingbird
WORKDIR /opt/hummingbird

COPY Gemfile /opt/hummingbird/
COPY Gemfile.lock /opt/hummingbird/

RUN bash -c "source /usr/local/rvm/scripts/rvm && \ 
    bundle install"

COPY . /opt/hummingbird

RUN cd /opt/hummingbird/frontend && \
    npm install && \
    bower --allow-root install

RUN npm install --save-dev ember-cli-rails-addon@0.0.11

EXPOSE 3000

ENTRYPOINT ["/opt/hummingbird/script/entrypoint.sh"]
CMD ["bundle", "exec", "foreman", "start"]


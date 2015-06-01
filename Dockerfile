FROM phusion/baseimage

MAINTAINER Hummingbird Media, Inc.

# Dependencies: PG client
RUN apt-get update && \
    apt-get install -y curl git postgresql-contrib libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# RVM
RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable --ruby=2.1.3

# NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.3/install.sh | bash && \
    bash -c "source ~/.nvm/nvm.sh && \
    nvm install v0.12 && \
    nvm alias default v0.12 && \
    npm install -g ember-cli bower"

# Hummingbird
WORKDIR /opt/hummingbird

COPY Gemfile /opt/hummingbird/
COPY Gemfile.lock /opt/hummingbird/

RUN bash -c "source /usr/local/rvm/scripts/rvm && \ 
    gem install bundler && \
    bundle install"

COPY . /opt/hummingbird

WORKDIR /opt/hummingbird/frontend
RUN bash -c "source ~/.nvm/nvm.sh && \
    npm install && \
    bower --allow-root install"

EXPOSE 3000

WORKDIR /opt/hummingbird
ENTRYPOINT ["/opt/hummingbird/bin/entrypoint.sh"]
CMD ["bundle", "exec", "foreman", "start", "--env=.env,.dockerenv"]


FROM phusion/baseimage
MAINTAINER Hummingbird Media, Inc.

# Dependencies: PG client
RUN apt-get update && \
    apt-get install -y curl git postgresql-contrib libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# RVM
RUN command curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable --ruby=2.2.3

# NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash && \
    bash -c "source ~/.nvm/nvm.sh && \
    nvm install v0.12 && \
    nvm alias default v0.12 && \
    npm install -g bower"

# Dependencies
RUN apt-get update && \
    apt-get install -y python libgmp3-dev && \
    rm -rf /var/lib/apt/lists/*

# Hummingbird
RUN mkdir -p /opt/hummingbird/server
WORKDIR /opt/hummingbird/server

COPY server/Gemfile /opt/hummingbird/server/
COPY server/Gemfile.lock /opt/hummingbird/server/

RUN bash -c "source /usr/local/rvm/scripts/rvm && \ 
    gem install bundler && \
    bundle install"

WORKDIR /opt/hummingbird
RUN bash -c "source /usr/local/rvm/scripts/rvm && \ 
    gem install bundler && \
    gem install foreman"

COPY . /opt/hummingbird

EXPOSE 3000
ENTRYPOINT ["/opt/hummingbird/entrypoint.sh"]
CMD ["foreman", "start", "--env=.dockerenv"]

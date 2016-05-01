FROM node:5.9
MAINTAINER Hummingbird Media, Inc.

RUN npm install -gq bower
RUN mkdir -p /opt/hummingbird/client

# Preinstall dependencies in an earlier layer so we don't reinstall every time
# any file changes.
COPY ./package.json /opt/hummingbird/client/
COPY ./bower.json /opt/hummingbird/client/
WORKDIR /opt/hummingbird/client
RUN npm install -q
RUN bower install --allow-root -q

# *NOW* we copy the codebase in
COPY . /opt/hummingbird/client

ENTRYPOINT ["./node_modules/.bin/ember"]
CMD ["serve", "--port=80", "--environment=development", "--watcher=polling"]
EXPOSE 80

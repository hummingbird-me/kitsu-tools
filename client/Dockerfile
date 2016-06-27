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
# If you are using Docker for Windows or Docker Toolbox, you may want to add the
# following parameter: --watcher=polling
CMD ["serve", "--port=80", "--environment=development", "--live-reload-port=57777"]
EXPOSE 57777
EXPOSE 80

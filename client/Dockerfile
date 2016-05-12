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
# Until Docker for Mac/Windows are common, we should use the polling watcher,
# because inotify events aren't proxied from the host machine.
CMD ["serve", "--port=80", "--environment=development", "--watcher=polling", "--live-reload-port=57777"]
EXPOSE 57777
EXPOSE 80

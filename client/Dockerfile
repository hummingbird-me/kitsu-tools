FROM node:5.5
MAINTAINER Hummingbird Media, Inc.

RUN npm install -gq bower
RUN mkdir -p /opt/hummingbird/client
COPY . /opt/hummingbird/client

WORKDIR /opt/hummingbird/client
RUN npm install -q
RUN bower install --allow-root -q

ENTRYPOINT ["./node_modules/.bin/ember"]
CMD ["server", "--port 80", "--environment development"]
EXPOSE 80

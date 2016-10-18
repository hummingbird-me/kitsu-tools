# Hummingbird

Hummingbird is a modern anime discovery platform that helps you track the anime you're watching, discover new anime and socialize with other fans.

---
**<p align="center">This branch is our under-development next-generation platform, not the one currently at hummingbird.me<br /><br />This is our meta repository. It contains all our tooling and binstubs.<br />For the actual source code, please check out the [server](https://github.com/hummingbird-me/hummingbird-server) and [client](https://github.com/hummingbird-me/hummingbird-client) repository.</p>**

---

[![Hummingbird is now Open Source](http://hummingbird-forum.s3.amazonaws.com/86407dbb64dbecfee0cbd74b759a4b33f70657b74c29.jpg)](http://forums.hummingbird.me/t/hummingbird-is-now-open-source/9870)


| [Server Repository](https://github.com/hummingbird-me/hummingbird-server) | [Client Repository](https://github.com/hummingbird-me/hummingbird-client) |
|:-------------:|:-------------:|
| [![Build Status](https://travis-ci.org/hummingbird-me/hummingbird-server.svg?branch=the-future)](https://travis-ci.org/hummingbird-me/hummingbird-server) [![Code Climate](https://codeclimate.com/github/hummingbird-me/hummingbird-server/badges/gpa.svg)](https://codeclimate.com/github/hummingbird-me/hummingbird-server) [![Test Coverage](https://codeclimate.com/github/hummingbird-me/hummingbird-server/badges/coverage.svg)](https://codeclimate.com/github/hummingbird-me/hummingbird-server/coverage)      | [![Build Status](https://travis-ci.org/hummingbird-me/hummingbird-client.svg?branch=the-future)](https://travis-ci.org/hummingbird-me/hummingbird-client) [![Code Climate](https://codeclimate.com/github/hummingbird-me/hummingbird-client/badges/gpa.svg)](https://codeclimate.com/github/hummingbird-me/hummingbird-client) [![Test Coverage](https://codeclimate.com/github/hummingbird-me/hummingbird-client/badges/coverage.svg)](https://codeclimate.com/github/hummingbird-me/hummingbird-client/coverage) |


## Contributing
The backend is a JSON API server built with Rails, Postgres, ElasticSearch, and Redis. The frontend is a client-side application written using Ember.

You can set up your own local development environment in just a few steps.    
If you prefer more detailed instructions for point **2** and **3**, head over to our [Setup instructions](https://github.com/hummingbird-me/hummingbird/wiki/Setting-up-a-development-environment#docker-recommended)

1. Read our short [Contributing Guide](https://github.com/hummingbird-me/hummingbird/blob/master/CONTRIBUTING.md)
2. If you don't already have, install docker on your system
 - For Mac, check out [Docker for Mac](https://docs.docker.com/docker-for-mac/)     
 - For Windows, check out [Docker for Windows](https://docs.docker.com/docker-for-windows/)
 - For Linux, manually install `docker` and `docker-compose` via your repository's package manager
3. Run `bin/setup` and follow the instructions. (This will also validate your docker installation)
4. Follow the quick [Filling the Database](https://github.com/hummingbird-me/hummingbird/wiki/Filling-the-Database#get-data-into-your-development-server) guide for getting some data to play with 

If you have any questions don't hesitate to contact us! Feel free to create a topic in the [forum dev category](http://forums.hummingbird.me/category/dev) or [email Josh](mailto:josh@hummingbird.me) to get access to our Slack.

For ideas of things to do, see our GitHub issues — check out the issues tagged "easy" for a good starting place!

Please don't use Github issues for feature requests, instead create a topic in the [forum feedback category](http://forums.hummingbird.me/category/feedback).


## Screenshots
[![Library Page](https://a.pomf.cat/wuigre.png)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/122667531)
[![Profile Page](https://a.pomf.cat/ljwmcn.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/105637573)
[![Browse Page](https://a.pomf.cat/jiliwf.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/104358379)
[![Preview Modal](https://a.pomf.cat/ajlsud.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/104250303)
[![Dashboard Page](https://a.pomf.cat/anxjco.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/103968010)


## License
Copyright 2015 Hummingbird Media, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

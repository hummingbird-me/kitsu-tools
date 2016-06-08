# Hummingbird

[![Build Status](https://secure.travis-ci.org/hummingbird-me/hummingbird.png?branch=master)](http://travis-ci.org/hummingbird-me/hummingbird) [![Code Climate](https://codeclimate.com/github/hummingbird-me/hummingbird.png)](https://codeclimate.com/github/hummingbird-me/hummingbird) [![Coverage](https://codeclimate.com/github/hummingbird-me/hummingbird/coverage.png)](https://codeclimate.com/github/hummingbird-me/hummingbird)


---
**<p align="center">This branch is our under-development next-generation platform, not the one currently at hummingbird.me</p>**

---

[![Hummingbird is now Open Source](http://hummingbird-forum.s3.amazonaws.com/86407dbb64dbecfee0cbd74b759a4b33f70657b74c29.jpg)](http://forums.hummingbird.me/t/hummingbird-is-now-open-source/9870)

### What is Hummingbird?

Hummingbird is a modern anime discovery platform that helps you track the anime you're watching, discover new anime and socialize with other fans.

### Contributing

The backend is a JSON API server built with Rails, Postgres, ElasticSearch, and Redis. The frontend is a client-side application written using Ember.

To get started, clone this repository, install Docker (via Docker for Mac/Windows or Docker-Machine if you're not on Linux) and run `bin/setup && bin/start` to get a development version running. Before you start working be sure to read the [contribution guide](https://github.com/hummingbird-me/hummingbird/blob/the-future/.github/CONTRIBUTING.md).

To get data into your development server:

1. Download [our media database dump](https://www.dropbox.com/s/ui1xaialiq67bnu/anime.sql.gz?dl=0)
2. Import the dump to your database:
   
   ```
   gzcat anime.sql.gz | bin/psql hummingbird_development
   ```
3. Set up Elasticsearch:

   ```
   bin/rake chewy:reset`
   ```

If you have any questions don't hesitate to contact us! Feel free to create a topic in the [forum dev category](http://forums.hummingbird.me/category/dev) or [email Josh](mailto:josh@hummingbird.me) to get access to our Slack.

For ideas of things to do, see our GitHub issues — check out the issues tagged "easy" for a good starting place!

Please don't use Github issues for feature requests, instead create a topic in the [forum feedback category](http://forums.hummingbird.me/category/feedback).

### Screenshots

[![Library Page](https://a.pomf.cat/wuigre.png)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/122667531)
[![Profile Page](https://a.pomf.cat/ljwmcn.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/105637573)
[![Browse Page](https://a.pomf.cat/jiliwf.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/104358379)
[![Preview Modal](https://a.pomf.cat/ajlsud.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/104250303)
[![Dashboard Page](https://a.pomf.cat/anxjco.jpg)](https://projects.invisionapp.com/share/3S4CAESCZ#/screens/103968010)

### License

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

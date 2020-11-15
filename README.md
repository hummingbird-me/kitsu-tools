# Kitsu

Kitsu is a modern content discovery platform that helps anime and manga fans track, share and discover more of what they love.

---
**<p align="center">This is our meta repository. It contains our development environment and tooling.<br />Check out the [web], [mobile], [server] and [api docs] repositories.</p>**

---

| [Server][server] | [Web][web] | [Mobile App][mobile] | [API Docs][api docs]
| :--------------: | :--------: | :------------------: | :------------------:
| ![][server-test] ![][server-api] <br> [![][server-codeclimate]][server-codeclimate-link] [![][server-crowdin]][server-crowdin-link] | ![][web-test] ![][web-deploy] <br> [![][web-codeclimate]][web-codeclimate-link] [![][web-crowdin]][web-crowdin-link] | [![][mobile-travis]][mobile-travis-link] | [![][api-deploy]][api-deploy-link]

[web]:https://github.com/hummingbird-me/kitsu-web
[server]:https://github.com/hummingbird-me/kitsu-server
[mobile]:https://github.com/hummingbird-me/kitsu-mobile
[api docs]:https://github.com/hummingbird-me/api-docs

[server-test]:https://github.com/hummingbird-me/kitsu-server/workflows/Kitsu%20Test%20Suite/badge.svg
[server-api]:https://github.com/hummingbird-me/kitsu-server/workflows/Kitsu%20API%20Deployment/badge.svg
[server-codeclimate]:https://badgen.net/codeclimate/maintainability/hummingbird-me/kitsu-server
[server-codeclimate-link]:https://codeclimate.com/github/hummingbird-me/kitsu-server
[server-crowdin]:https://badges.crowdin.net/kitsu-server/localized.svg
[server-crowdin-link]:https://crowdin.com/project/kitsu-server

[web-test]:https://github.com/hummingbird-me/kitsu-web/workflows/Kitsu%20Test%20Suite/badge.svg
[web-deploy]:https://github.com/hummingbird-me/kitsu-web/workflows/Kitsu%20Web%20Deployment/badge.svg
[web-codeclimate]:https://badgen.net/codeclimate/maintainability/hummingbird-me/kitsu-web
[web-codeclimate-link]:https://codeclimate.com/github/hummingbird-me/kitsu-web
[web-crowdin]:https://badges.crowdin.net/kitsu-web/localized.svg
[web-crowdin-link]:https://crowdin.com/project/kitsu-web

[mobile-travis]:https://badgen.net/travis/hummingbird-me/kitsu-mobile/develop
[mobile-travis-link]:https://travis-ci.org/hummingbird-me/kitsu-mobile

[api-deploy]:https://github.com/hummingbird-me/api-docs/workflows/API%20Docs%20Deployment/badge.svg
[api-deploy-link]:https://hummingbird-me.github.io/api-docs/

## Contributing

The backend is an API server built with Rails, Postgres, and Redis. The frontend is a client-side application written using Ember.  The mobile app is a cross-platform native app using React Native.

You can set up your own local development environment in just a few steps.    
If you prefer more detailed instructions for point **2** and **3**, head over to our [Setup instructions](https://github.com/hummingbird-me/hummingbird/wiki/Setting-up-a-development-environment#docker-recommended)

1. Read our short [Contributing Guide](https://github.com/hummingbird-me/hummingbird/blob/the-future/CONTRIBUTING.md)
2. [Install docker](https://docs.docker.com/get-docker/)
3. Run `bin/setup` and follow the instructions. (This will also validate your docker installation)
4. Follow the quick [Filling the Database](https://github.com/hummingbird-me/hummingbird/wiki/Filling-the-Database#get-data-into-your-development-server) guide for getting some data to play with

If you have any questions don't hesitate to contact us [in our Discord](https://invite.gg/kitsu).

For ideas of things to do, see our GitHub issues — check out the issues tagged "easy" for a good starting place!

Please don't use Github issues for feature requests, instead create a [feature request](https://kitsu.io/feedback/feature-requests) on Kitsu.

## Contributors

[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/0)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/0)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/1)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/1)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/2)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/2)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/3)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/3)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/4)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/4)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/5)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/5)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/6)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/6)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/images/7)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-tools/links/7)

## License
Copyright 2020 Kitsu, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

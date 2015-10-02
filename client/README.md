# Hummingbird Client

This README outlines the details of collaborating on this Ember application.

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).

### Running Tests

* `ember test`
* `ember test --server`

### Styleguide

* [JavaScript](https://github.com/dockyard/styleguides/blob/master/javascript.md)
* [Ember](https://github.com/dockyard/styleguides/blob/master/ember.md)

We use a different pod structure than DockYard. The structure belows is based on
the discussion here: https://github.com/ember-cli/ember-cli/issues/4044

Basically, routes should be under `app/pods`, and anything that can be considered application-wide should be under `app/`.

```
app
  components/
    one-way-input/
      component.js
      template.hbs
  models/
    user/
      model.js
      adapter.js
      serializer.js
  services/
    current-session.js
  pods/
    dashboard/
      components/
        dashboard-only-component
          component.js
          template.hbs
      component.js
      route.js
      template.hbs
```

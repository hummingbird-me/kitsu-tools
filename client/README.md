# Hummingbird Client

This README outlines the details of collaborating on this application.

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
app/
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

# Hummingbird Client

This README outlines the details of collaborating on this application.

### Running Tests

* `ember test`
* `ember test --server`

### Styleguide

* [JavaScript](https://github.com/dockyard/styleguides/blob/master/engineering/javascript.md)
* [Ember](https://github.com/dockyard/styleguides/blob/master/engineering/ember.md)

#### Amendments

##### Do overwrite init

ES6 spread operator allows for calling `return this._super(...arguments);`.
This approach provides better performance as well.

https://dockyard.com/blog/2015/10/19/2015-dont-dont-override-init

##### Pods

We use a slightly different pod structure to what DockYard specify in their styleguide above.

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
  routes/
    dashboard/
      components/
        dashboard-only-component
          component.js
          template.hbs
      component.js
      route.js
      template.hbs
```

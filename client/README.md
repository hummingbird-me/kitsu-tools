# Hummingbird Client

This README outlines the details of collaborating on this application.

### Running Tests

* `ember test`
* `ember test --server`

### Styleguide

* [JavaScript](https://github.com/dockyard/styleguides/blob/master/engineering/javascript.md)
* [Ember](https://github.com/dockyard/styleguides/blob/master/engineering/ember.md)

#### Amendments

##### Const

Use `const` for variables over `var` & `let` that aren't mutated, `let` otherwise.

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

### Testing

When writing Acceptance tests, use the `data-test-selector` property to determine if HTML elements exist within the page.

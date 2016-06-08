# Hummingbird Client

This README outlines the details of collaborating on this application.

## Styleguide

* [JavaScript](https://github.com/dockyard/styleguides/blob/master/engineering/javascript.md) - [Amendments](https://github.com/hummingbird-me/hummingbird/blob/the-future/client/README.md#javascript)
* [Ember](https://github.com/dockyard/styleguides/blob/master/engineering/ember.md) - [Amendments](https://github.com/hummingbird-me/hummingbird/blob/the-future/client/README.md#ember)

## Styleguide Amendments

### JavaScript

#### Assignment

Use `const` for all of your references; If you must reassign references, use `let` instead of `var`.

>Why? This ensures that you can't reassign your references, which can lead to bugs and difficult to comprehend code.

> Why? let is block-scoped rather than function-scoped like var.

### Ember

#### Import what you use, do not use globals

For Ember Data, we should import `ember-data` modules. For Ember, we should import via [ember-cli-shims](https://github.com/ember-cli/ember-cli-shims).

```javascript
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import computed from 'ember-computed';

export default Model.extend({
  firstName: attr('string'),
  lastName: attr('string'),

  fullName: computed('firstName', 'lastName', {
    get() {
      // Code
    }
  }).readOnly()
});
```

#### Use Pods structure

Our directory structure is different to the defined structure in the DockYard styleguide.

This will change again when this [Ember RFC](https://github.com/emberjs/rfcs/pull/143) is completed.

```
app/
  components/
    shared-component/
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
        route-specific-component
          component.js
          template.hbs
      controller.js
      route.js
      template.hbs
```

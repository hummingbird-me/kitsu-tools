Hummingbird.ApplicationStore = DS.Store.extend({
  revision: 13
});

Hummingbird.ApplicationAdapter = DS.ActiveModelAdapter.extend({});
Hummingbird.ApplicationSerializer = DS.ActiveModelSerializer.extend({});

Hummingbird.CurrentUserAdapter = DS.ActiveModelAdapter.extend({
  pathForType: function (type) {
    return 'users';
  }
});

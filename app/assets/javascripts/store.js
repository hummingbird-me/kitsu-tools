HB.ApplicationStore = DS.Store.extend({
  revision: 13
});

HB.ApplicationAdapter = DS.ActiveModelAdapter.extend({});
HB.ApplicationSerializer = DS.ActiveModelSerializer.extend({});

HB.CurrentUserAdapter = DS.ActiveModelAdapter.extend({
  pathForType: function (type) {
    return 'users';
  }
});

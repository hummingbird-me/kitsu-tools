HB.CurrentUser = HB.User.extend({
  newUsername: DS.attr('string'),
  email: DS.attr('string'),
  newPassword: DS.attr('string'),
  sfwFilter: DS.attr('boolean'),
  lastBackup: DS.attr('date'),
  hasDropbox: DS.attr('boolean'),
  hasFacebook: DS.attr('boolean'),
  confirmed: DS.attr('boolean')
});

HB.CurrentUserAdapter = DS.ActiveModelAdapter.extend({
  pathForType: function(type) {
    return 'users';
  }
});

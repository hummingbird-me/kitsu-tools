Hummingbird.CurrentUser = Hummingbird.User.extend({
  email: DS.attr('string'),
  password: DS.attr('string'),
  sfwFilter: DS.attr('boolean'),
  lastBackup: DS.attr('date'),
  hasDropbox: DS.attr('boolean')
});

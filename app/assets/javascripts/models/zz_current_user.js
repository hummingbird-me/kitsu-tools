Hummingbird.CurrentUser = Hummingbird.User.extend({
  email: DS.attr('string'),
  password: DS.attr('string'),
  adultFilter: DS.attr('boolean'),
  ratingSystem: DS.attr('string'),
  lastBackup: DS.attr('date'),
  hasDropbox: DS.attr('boolean')
});

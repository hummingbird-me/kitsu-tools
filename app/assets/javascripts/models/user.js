HB.User = DS.Model.extend({
  username: Ember.computed.alias('id'),
  coverImageUrl: DS.attr('string'),
  avatarTemplate: DS.attr('string'),
  online: DS.attr('boolean'),
  miniBio: DS.attr('string'),
  bio: DS.attr('string'),
  location: DS.attr('string'),
  website: DS.attr('string'),
  waifu: DS.attr('string'),
  waifuOrHusbando: DS.attr('string'),
  ratingType: DS.attr('string'),
  waifuCharId: DS.attr('string'),
  waifuSlug: DS.attr('string'),
  isFollowed: DS.attr('boolean'),
  titleLanguagePreference: DS.attr('string'),
  isAdmin: DS.attr('boolean'),
  followerCount: DS.attr('number'),
  followingCount: DS.attr('number'),

  avatarUrl: function() {
    return this.get("avatarTemplate").replace('{size}', 'thumb');
  }.property('avatarTemplate'),

  coverImageStyle: function() {
    return "background-image: url(" + this.get('coverImageUrl') + ")";
  }.property('coverImageUrl'),

  userLink: function() {
    return "/users/" + this.get('id');
  }.property('id'),

  websiteLink: function() {
    if (this.get("website") &&
      this.get("website").search(/^http[s]?\:\/\//) == -1) {
      return 'http://' + this.get("website");
    } else {
      return this.get("website");
    }
  }.property('website'),

  truncatedBio: function () {
    if(!this.get('miniBio')) return "";
    if (this.get('miniBio').length <= 140) return this.get('miniBio');
    return this.get('miniBio').slice(0,137) + '...';
  }.property('miniBio')
});

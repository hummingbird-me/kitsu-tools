import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  username: Ember.computed.alias('id'),
  coverImageUrl: DS.attr('string'),
  avatarTemplate: DS.attr('string'),
  miniBio: DS.attr('string'),
  about: DS.attr('string'),
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
  isPro: DS.attr('boolean'),
  followerCount: DS.attr('number'),
  followingCount: DS.attr('number'),
  favorites: DS.hasMany('favorite', { async: true }),

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
      this.get("website").search(/^http[s]?\:\/\//) === -1) {
      return 'http://' + this.get("website");
    } else {
      return this.get("website");
    }
  }.property('website'),

  truncatedBio: function(key, value) {
    // setter
    if (arguments.length > 1) {
      this.set('miniBio', value.slice(0, 140));
    }

    // getter
    return this.get('miniBio') || "";
  }.property('miniBio'),

  truncatedAbout: function(key, value) {
    // setter
    if (arguments.length > 1) {
      this.set('about', value.slice(0, 500));
    }

    // getter
    return this.get('about') || "";
  }.property('about')
});

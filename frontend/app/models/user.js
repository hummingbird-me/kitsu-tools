import Ember from 'ember';
import DS from 'ember-data';
import ModelTruncatedDetails from '../mixins/model-truncated-details';

export default DS.Model.extend(ModelTruncatedDetails, {
  username: Ember.computed.alias('id'),
  coverImageUrl: DS.attr('string'),
  avatarTemplate: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  aboutFormatted: DS.attr('string'),
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

  aboutDisplay: Ember.computed.any('aboutFormatted', 'about'),

  avatarUrl: function() {
    return this.get("avatarTemplate").replace('{size}', 'thumb');
  }.property('avatarTemplate'),

  coverImageStyle: function() {
    let coverImage = this.get('coverImageUrl');
    return (`background-image: url('${coverImage}')`).htmlSafe();
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
  }.property('website')
});

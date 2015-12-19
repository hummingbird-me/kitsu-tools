import Ember from 'ember';
import DS from 'ember-data';

const { computed } = Ember;
const { Model, attr } = DS;

export default Model.extend({
  about: attr('string'),
  aboutFormatted: attr('string'),
  avatar: attr('string'),
  bio: attr('string'),
  coverImage: attr('string'),
  email: attr('string'), // @Note: Used for user creation
  followersCount: attr('number'),
  followingCount: attr('number'),
  location: attr('string'),
  onboarded: attr('boolean'),
  password: attr('string'), // @Note: Used for user creation
  pastNames: attr('array'),
  name: attr('string'),
  ratingSystem: attr('number'), // @Note: 1 === smile, 2 === star
  toFollow: attr('boolean'),
  waifuOrHusbando: attr('string'),
  website: attr('string'),

  isSmileRating: computed.equal('ratingSystem', 1),
  isStarRating: computed.equal('ratingSystem', 2)
});

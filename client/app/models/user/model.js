import Ember from 'ember';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';

const {
  computed: { equal }
} = Ember;

export default Model.extend({
  about: attr('string'),
  aboutFormatted: attr('string'),
  avatar: attr('string'),
  bio: attr('string'),
  coverImage: attr('string'),
  email: attr('string'),
  followersCount: attr('number'),
  followingCount: attr('number'),
  location: attr('string'),
  onboarded: attr('boolean'),
  password: attr('string'),
  pastNames: attr('array'),
  name: attr('string'),
  ratingSystem: attr('number'),
  toFollow: attr('boolean'),
  waifuOrHusbando: attr('string'),
  website: attr('string'),

  isSmileRating: equal('ratingSystem', 1),
  isStarRating: equal('ratingSystem', 2)
});

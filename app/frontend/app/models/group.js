import Ember from 'ember';
import DS from 'ember-data';
import ModelTruncatedDetails from '../mixins/model-truncated-details';

export default DS.Model.extend(ModelTruncatedDetails, {
  name: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  aboutFormatted: DS.attr('string'),
  coverImageUrl: DS.attr('string'),
  avatarUrl: DS.attr('string'),
  memberCount: DS.attr('number'),
  currentMember: DS.belongsTo('group-member'),

  aboutDisplay: Ember.computed.any('aboutFormatted', 'about'),
  coverImageStyle: function() {
    return "background: url(" + this.get('coverImageUrl') + ") center;";
  }.property('coverImageUrl')
});

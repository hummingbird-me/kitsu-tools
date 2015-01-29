import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  bio: DS.attr('string'),
  about: DS.attr('string'),
  coverImage: DS.attr('string'),
  avatar: DS.attr('string'),
  memberCount: DS.attr('number'),
  members: DS.hasMany('group-member'),

  // Fixes the fact that viewing all members adds to the members
  // association.
  recentMembers: function() {
    var members = this.get('members');
    return members.filterBy('pending', false).slice(0, 14);
  }.property('members.@each'),

  isMember: function(user) {
    return this.get('members').filterBy('pending', false)
      .findBy('user.id', user.get('id'));
  },

  truncatedBio: function(key, value) {
    // setter
    if (arguments.length > 1) {
      this.set('bio', value.slice(0, 140));
    }

    // getter
    return this.get('bio') || "";
  }.property('bio'),

  truncatedAbout: function(key, value) {
    // setter
    if (arguments.length > 1) {
      this.set('about', value.slice(0, 500));
    }

    // getter
    return this.get('about') || "";
  }.property('about')
});

import DS from 'ember-data';

export default DS.Model.extend({
  // FIXME Why is this needed? Needed for dirty checking? What is dirty checking?
  // introduced in comment: 18fc748e4085ffadeac19658273557d899babbd0
  anime_id: DS.attr('string'),

  characterName: DS.attr('string'),
  content: DS.attr('string'),
  username: DS.attr('string'),
  favoriteCount: DS.attr('number'),
  isFavorite: DS.attr('boolean')
});

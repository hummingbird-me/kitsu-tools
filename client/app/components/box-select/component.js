import Ember from 'ember';

const {
  Component,
  get,
  set,
  getProperties,
  computed
} = Ember;

export default Component.extend({
  choices: {},
  chosen: [],
  onSet: function () {},

  choiceList: computed('choices', 'chosen', function () {
    const {choices, chosen} = getProperties(this, ['choices', 'chosen']);
    const permitted = chosen.filter((c) => choices[c]);
    return choices.map((choice) => {
      const out = Object.create(choice);
      set(out, 'selected', chosen.indexOf(choice.key) != -1);
      return out;
    });
  }),

  actions: {
    toggle: function (choice) {
      let chosen = get(this, 'chosen');
      const choices = get(this, 'choices');

      if (chosen.indexOf(choice.key) != -1) {
        chosen = chosen.filter((k) => k != choice.key);
      } else {
        chosen.push(choice.key);
      }
      get(this, 'onSet')(chosen);
    }
  }
});

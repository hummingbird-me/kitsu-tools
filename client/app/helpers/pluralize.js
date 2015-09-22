import Ember from 'ember';

export function pluralize(number, { single, plural }) {
  const word = (number === 1 ? single : plural);
  return `${number} ${word}`;
}

// Usage: {{pluralize 1 single="day" plural="days"}}
export default Ember.Helper.helper(pluralize);

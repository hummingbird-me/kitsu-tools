import Ember from 'ember';

const { Helper } = Ember;

export function pluralize(number, { single, plural }) {
  const word = (number === 1 ? single : plural);
  return `${number} ${word}`;
}

// Usage: {{pluralize 1 single="day" plural="days"}}
export default Helper.helper(pluralize);

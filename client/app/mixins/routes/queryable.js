import Mixin from 'ember-metal/mixin';
import { typeOf, isEmpty } from 'ember-utils';

export default Mixin.create({
  /**
   * Serializes range and array query params.
   */
  serializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      if (typeOf(value) !== 'array') {
        value = this.deserializeQueryParam(...arguments);
      }
      const isRange = typeOf(value[0]) !== 'string';
      if (isRange && value.length === 2) {
        return value.join('..');
      } else if (!isRange && value.length > 1) {
        return value.reject((x) => isEmpty(x)).join();
      }
      return value.join();
    }
    return this._super(...arguments);
  },

  /**
   * Deserializes range and array query params.
   */
  deserializeQueryParam(value, _, defaultValueType) {
    if (defaultValueType === 'array') {
      const isRange = value.includes('..');
      if (isRange) {
        return value.split('..').map((x) => {
          if (Number.isInteger(JSON.parse(x))) {
            return parseInt(x, 10);
          } else {
            return parseFloat(x);
          }
        });
      }
      return value.split(',');
    }
    return this._super(...arguments);
  }
});

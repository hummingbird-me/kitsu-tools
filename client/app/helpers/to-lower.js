import { helper } from 'ember-helper';
import { isEmberArray as isArray } from 'ember-array/utils';

/**
 * Supports calling `toLowerCase` on a single property, or on each
 * property in an array.
 */
export function toLower([target]) {
  target = target || '';
  if (isArray(target)) {
    return target.map((x) => x.toLowerCase());
  }
  return target.toLowerCase();
}

export default helper(toLower);

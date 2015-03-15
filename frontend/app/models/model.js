/**
 * Temporary hack to get polymorphic relations working with different base
 * classes.
 *
 * Will no longer be needed once this PR lands in Ember Data:
 * https://github.com/emberjs/data/pull/2586
 *
 */

import DS from 'ember-data';

export default DS.Model.extend({
});

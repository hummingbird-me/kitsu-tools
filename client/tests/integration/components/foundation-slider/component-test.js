import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-slider', 'Integration | Component | foundation slider', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(0);
  this.render(hbs`{{foundation-slider
    doubleSided=true decimal=0
  }}`);
});

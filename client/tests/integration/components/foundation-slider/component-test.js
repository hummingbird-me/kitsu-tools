import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-slider', 'Integration | Component | foundation slider', {
  integration: true
});

test('it renders a single handled slider', function(assert) {
  this.render(hbs`{{foundation-slider doubleSided=false}}`);
  const slider = this.$('.noUi-handle');
  assert.equal(slider.length, 1);
});

test('it renders a two handled slider', function(assert) {
  this.render(hbs`{{foundation-slider doubleSided=true}}`);
  const slider = this.$('.noUi-handle');
  assert.equal(slider.length, 2);
});

test('decimals are respected and actions are called', function(assert) {
  // update is called 3 times by both sets, and the mouse click
  // release is called once by the simulated mouse click
  assert.expect(6);
  this.set('update', () => assert.ok(true));
  this.set('release', () => assert.ok(true));
  this.render(hbs`
    {{foundation-slider
        initialStart=50 initialEnd=90 doubleSided=true
        decimal=2 step=0.01
        onUpdate=(action update)
        onRelease=(action release)
    }}
  `);

  const [$el] = this.$('.noUi-target');
  assert.deepEqual($el.noUiSlider.get(), [50, 90]);
  $el.noUiSlider.set([25.125, null]);
  assert.deepEqual($el.noUiSlider.get(), [25.13, 90]);

  // trigger an actual click to proc the 'slide' event
  const offset = (el) => {
    const rect = el.getBoundingClientRect();
    return {
      x: rect.left + this.$()[0].scrollLeft,
      y: rect.top + this.$()[0].scrollTop
    };
  };
  const event = document.createEvent('MouseEvents');
  event.initMouseEvent('mousedown', true, true, window, null, 0, 0,
    offset($el).left + 100, offset($el).top + 8, '',
    false, false, false, false, 0, null);
  $el.querySelectorAll('.noUi-origin')[0].dispatchEvent(event);
});

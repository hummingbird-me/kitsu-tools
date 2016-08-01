import Component from 'ember-component';
import get from 'ember-metal/get';
/* global noUiSlider */

export default Component.extend({
  classNames: ['slider'],
  start: 0,
  end: 100,
  step: 1,
  initialStart: 0,
  initialEnd: 100,
  doubleSided: false,
  decimal: 2,

  didInsertElement() {
    this._super(...arguments);
    const [$el] = this.$();
    const selected = [get(this, 'initialStart')];
    if (get(this, 'doubleSided') === true) {
      selected.push(get(this, 'initialEnd'));
    }

    const decimal = get(this, 'decimal');
    noUiSlider.create($el, {
      start: selected,
      connect: get(this, 'doubleSided'),
      step: get(this, 'step'),
      range: {
        'min': get(this, 'start'),
        'max': get(this, 'end')
      },
      format: {
        to(value) {
          return parseFloat(parseFloat(value).toFixed(decimal));
        },

        from(value) {
          return value;
        }
      }
    });
    $el.noUiSlider.on('slide', (values) => get(this, 'onUpdate')(values));
    $el.noUiSlider.on('set', () => get(this, 'onRelease')());
  }
});

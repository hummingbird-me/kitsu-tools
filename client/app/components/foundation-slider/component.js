import Component from 'ember-component';
import get from 'ember-metal/get';
/* global noUiSlider */

export default Component.extend({
  start: 0,
  end: 100,
  step: 1,
  initialStart: 0,
  initialEnd: 100,
  clickSelect: true,
  vertical: false,
  draggable: true,
  disabled: false,
  doubleSided: false,
  decimal: 2,
  moveTime: 200,
  disabledClass: 'disabled',
  classNames: 'slider',

  didInsertElement() {
    this._super(...arguments);
    /* TO BE ENABLED AFTER zurb/foundation-sites#7730 IS FIXED!
    new Foundation.Slider(this.$(), getProperties(this, [
      'start', 'end', 'initialStart', 'initialEnd', 'clickSelect', 'vertical',
      'draggable', 'disabled', 'doubleSided', 'decimal', 'moveTime',
      'disabledClass'
    ]));
    this.$().on('moved.zf.slider', () => {
      const values = this.$('input').map(function () { return this.value });
      this.sendAction('update', values.toArray());
    });
    */
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

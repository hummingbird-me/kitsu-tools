import Ember from 'ember';
/* global noUiSlider */

const {
  get,
} = Ember;

export default Ember.Component.extend({
  /**
    Minimum value for the slider scale.
  */
  start: 0,
  /**
    Maximum value for the slider scale.
  */
  end: 100,
  /**
    Minimum value change per change event.
  */
  step: 1,
  /**
    Value at which the first/left handle/input should be set to on
    initialization.
  */
  initialStart: 0,
  /**
    Value at which the second/right handle/input should be set to on
    initialization.
  */
  initialEnd: 100,
  /**
    Allows the user to click/tap on the slider bar to select a value
  */
  clickSelect: true,
  /**
    Set to true and use the `vertical` class to change alignment to vertical.
  */
  vertical: false,
  /**
    Allows the user to drag the slider handle(s) to select a value
  */
  draggable: true,
  /**
    Disables the slider and prevents event listeners from being applied. Double
    checked by JS with `disabledClass`
  */
  disabled: false,
  /**
    Allows the use of two handles.  Double checked by the JS.  Changes some
    logic handling.
  */
  doubleSided: false,
  /**
    Number of decimal places the plugin should go to for floating-point
    precision.
  */
  decimal: 2,
  /**
    Time, in ms, to animate the movement of a slider handle if suer clicks/taps
    on the bar.  Neebe manually set if updating the transiton time in the Sass
    settings.
  */
  moveTime: 200,
  /**
    Class applied to disabled sliders
  */
  disabledClass: 'disabled',
  classNames: 'slider',

  didInsertElement() {
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
    const $el = this.$()[0];
    const selected = [get(this, 'initialStart')];
    if (get(this, 'doubleSided') === true) {
      selected.push(get(this, 'initialEnd'));
    }

    const decimal = get(this, 'decimal');
    noUiSlider.create($el, {
      start: selected,
      connect: true,
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

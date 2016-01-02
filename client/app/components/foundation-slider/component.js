import Ember from 'ember';

const {
  get,
  set,
  getProperties
} = Ember;

export default Ember.Component.extend({
  /**
   * Minimum value for the slider scale.
   * @default 0
   */
  start: 0,
  /**
   * Maximum value for the slider scale.
   * @default 100
   */
  end: 100,
  /**
   * Minimum value change per change event.
   * @default 1
   */
  step: 1,
  /**
   * Value at which the first/left handle/input should be set to on
   * initialization.
   * @default 0
   */
  initialStart: 0,
  /**
   * Value at which the second/right handle/input should be set to on
   * initialization.
   * @default 100
   */
  initialEnd: 100,
  /**
   * Allows the user to click/tap on the slider bar to select a value
   * @default true
   */
  clickSelect: true,
  /**
   * Set to true and use the `vertical` class to change alignment to vertical.
   * @default false
   */
  vertical: false,
  /**
   * Allows the user to drag the slider handle(s) to select a value
   * @default true
   */
  draggable: true,
  /**
   * Disables the slider and prevents event listeners from being applied. Double
   * checked by JS with `disabledClass`
   * @default false
   */
  disabled: false,
  /**
   * Allows the use of two handles.  Double checked by the JS.  Changes some
   * logic handling.
   * @default false
   */
  doubleSided: false,
  /**
   * Number of decimal places the plugin should go to for floating-point
   * precision.
   * @default 2
   */
  decimal: 2,
  /**
   * Time, in ms, to animate the movement of a slider handle if suer clicks/taps
   * on the bar.  Neebe manually set if updating the transiton time in the Sass
   * settings.
   * @default 200
   */
  moveTime: 200,
  /**
   * Class applied to disabled sliders
   * @default 'disabled'
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
    let el = this.$()[0];
    let selected = [get(this, 'initialStart')];
    if (get(this, 'doubleSided')) {
      selected.push(get(this, 'initialEnd'));
    }
    noUiSlider.create(el, {
      start: selected,
      connect: true,
      step: get(this, 'step'),
      range: {
        'min': get(this, 'start'),
        'max': get(this, 'end')
      }
    });
    el.noUiSlider.on('slide', (values) => this.sendAction('onUpdate', values));
    el.noUiSlider.on('set', (values) => this.sendAction('onRelease', values));
  }
});

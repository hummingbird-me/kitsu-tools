import Component from 'ember-cli-foundation-6-sass/components/zf-dropdown';
import get from 'ember-metal/get';

/**
 * Override the `zf-dropdown` component from `ember-cli-foundation-6-sass`
 * to allow for the dropdown to close when the pane or an item within is
 * clicked.
 */
export default Component.extend({
  closeOnClick: true,

  /**
   * Called by `ember-cli-foundation-6-sass` in an afterRender runloop
   */
  handleInsert() {
    this._super(...arguments);
    if (get(this, 'closeOnClick') === true) {
      this.$().on('click', () => {
        get(this, 'zfUi').close();
      });
    }
  },

  willDestroyElement() {
    this._super(...arguments);
    if (get(this, 'closeOnClick') === true) {
      this.$().off('click');
    }
  }
});

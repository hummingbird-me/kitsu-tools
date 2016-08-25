import Component from 'ember-cli-foundation-6-sass/components/zf-dropdown';
import get from 'ember-metal/get';
import jQuery from 'jquery';

/**
 * Override the `zf-dropdown` component from `ember-cli-foundation-6-sass`
 * to allow for the dropdown to close when the pane or an item within is
 * clicked.
 */
export default Component.extend({
  closeOnClick: true,

  handleInsert() {
    get(this, 'zfUi')._addBodyHandler = () => {
      jQuery(document.body)
        .off('click.zf.dropdown')
        .on('click.zf.dropdown', (e) => {
          // don't attempt to close if the component is destroyed
          if (get(this, 'isDestroyed') === false) {
            // don't close when clicking on the anchor element, it already
            // is set to toggle on click.
            if (get(this, 'zfUi').$anchor.is(e.target) === true) {
              return;
            }
            get(this, 'zfUi').close();
          }
          jQuery(document.body).off('click.zf.dropdown');
        });
    };
  }
});

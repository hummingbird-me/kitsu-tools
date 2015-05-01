import Ember from 'ember';
import ajax from 'ic-ajax';

export default Ember.Controller.extend({
  isRefilling: false,
  hasRefilled: false,

  actions: {
    uploadCodesFile: function(file) {
      this.set('isRefilling', true);

      var data = new FormData();
      data.append('codes', file);
      data.append('deal_id', this.get('id'));

      ajax({
        url: '/kotodama/refill_codes',
        type: 'POST',
        data: data,
        processData: false,
        contentType: false
      }).then(() => {
        this.setProperties({
          hasRefilled: true,
          isRefilling: false
        });
      }, () => {
        this.set('isRefilling', false);
      });
    }
  }
});

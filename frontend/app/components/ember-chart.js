import Ember from 'ember';
/* global Chart */

export default Ember.Component.extend({
  tagName: 'canvas',
  setup: false,

  didInsertElement: function(){
    var canvas  = this.get('element'),
        context = canvas.getContext('2d');

    canvas.width  = Ember.$(canvas).parent().width();
    canvas.height = Ember.$(canvas).parent().height();

    var data = this.get('data'),
        type = this.get('type').charAt(0).toUpperCase() + this.get('type').slice(1),
        options = (this.get('options') !== undefined) ? this.get('options') : {};

    if (!type.match(/(Line|Bar|Radar|PolarArea|Pie|Doughnut)/)) {
      type = "Line";
    }

    this.setProperties({
      '_data': data,
      '_type': type,
      '_canvas':  canvas,
      '_context': context,
      '_options': options
    });
    this.chartRender();
  },

  chartRender: function(){
    var chart = new Chart(this.get('_context'))[this.get('_type')](this.get('_data'),this.get('_options'));
    this.setProperties({
      '_chart': chart,
      'setup': true
    });
  },

  chartUpdate: function(){
    if(this.get('update') === true && this.get('setup') === true){
      this.chartRender();
    }
  }.observes('data', 'options')
});

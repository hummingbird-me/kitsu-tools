HB.KotodamaController = Ember.ObjectController.extend({

  graphOptions: [],
  graphData: function(){
    var data = this.get('content'),
        labels = Object.keys(data["registrations"]["total"]),
        confirmed = [],
        total = [];

    labels.forEach(function(key){
      confirmed.push(data["registrations"]["confirmed"][key]);
      total.push(data["registrations"]["total"][key]);
    });

    return {
      labels: Object.keys(this.get('content')["registrations"]["total"]),
      datasets: [   
        {
          fillColor : "rgba(220,220,220,0.5)",
          strokeColor : "rgba(220,220,220,1)",
          pointColor : "rgba(220,220,220,1)",
          pointStrokeColor : "#fff",
          data: total
        },
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data: confirmed
        }
      ]
    }
  }.property('content')

});

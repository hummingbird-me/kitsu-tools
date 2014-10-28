HB.KotodamaController = Ember.ObjectController.extend({

  nonMalAnime: window.genericPreload.nonmal_anime,
  blotter: window.genericPreload.blotter,
  blotterMesg: "",
  blotterLink: "",

  hasBlotter: Ember.computed.notEmpty('blotter'),
  hasDeployed: false,

  init: function(){
    var blotter = this.get('blotter');
    if(blotter){
      this.setProperties({
        'blotterMesg': blotter.message,
        'blotterLink': blotter.link
      });
    }

    this._super();
  },

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
  }.property('content'),


  actions: {
    deploy: function(){
      this.set('hasDeployed', false);
      $.post("/kotodama/deploy", function(payload){
        this.set('hasDeployed', true);
      });
    },

    reload: function(){
      window.location.reload();
    },

    clearBlotter: function(){
      var self = this;
      $.get("/kotodama/blotter_clear", function(payload){
        self.setProperties({
          hasBlotter: false,
          blotterMesg: "",
          blotterLink: ""
        });
      });
    }
  }

});

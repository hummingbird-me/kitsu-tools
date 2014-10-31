HB.KotodamaController = Ember.ObjectController.extend({

  nonMalAnime: window.genericPreload.nonmal_anime,
  blotter: window.genericPreload.blotter,
  blotterMesgFix: "",
  blotterMesg: "",
  blotterLink: "",

  hasBlotter: Ember.computed.notEmpty('blotter'),
  hasDeployed: false,
  showReports: false,
  showNonMal: false,

  reportedContent: ["quote:39248348", "comment:3948348"],

  accountsNew: function(){
    var statsObject = this.get('content.registrations.total');
    return statsObject[Object.keys(statsObject)[Object.keys(statsObject).length - 1]]
  }.property('content.registrations'),

  accountsCnf: function(){
    var statsObject = this.get('content.registrations.confirmed');
    return statsObject[Object.keys(statsObject)[Object.keys(statsObject).length - 1]]
  }.property('content.registrations'),

  init: function(){
    var blotter = this.get('blotter');
    if(blotter){
      this.setProperties({
        'blotterMesg': blotter.message,
        'blotterLink': blotter.link,
        'blotterMesgFix': blotter.message
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

    publishUpdate: function(){
      $.post("/kotodama/publish_update");
    },

    reload: function(){
      window.location.reload();
    },

    saveBlotter: function(){
      var self = this,
          query = "?icon=fa-exclamation-circle";

      query += "&message="+encodeURIComponent(this.get('blotterMesg'));
      query += "&link="+encodeURIComponent(this.get('blotterLink'));

      $.get("/kotodama/blotter_set"+query, function(payload){
        self.setProperties({
          hasBlotter: true,
          blotterMesgFix: self.get('blotterMesg')
        });
      });
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
    },

    toggleNonMal: function(){
      this.toggleProperty('showNonMal');
    }
  }

});

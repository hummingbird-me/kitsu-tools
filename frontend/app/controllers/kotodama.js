import Ember from 'ember';
import PreloadStore from '../utils/preload-store';

export default Ember.Controller.extend({
  nonMalAnime: PreloadStore.get('nonmal_anime'),
  blotter: PreloadStore.get('blotter'),
  partnerDeals: PreloadStore.get('deals_to_refill'),
  blotterMesgFix: "",
  blotterMesg: "",
  blotterLink: "",

  hasBlotter: Ember.computed.notEmpty('blotter'),
  hasDeployed: false,
  showReports: false,
  showNonMal: false,

  usersToFollow: function() {
    return this.store.find('user', {
      to_follow: true
    });
  }.property('userToFollowSubmit'),

  accountsNew: function() {
    var statsObject = this.get('model.registrations.total');
    return statsObject[Object.keys(statsObject)[Object.keys(statsObject).length - 1]];
  }.property('model.registrations'),

  accountsCnf: function() {
    var statsObject = this.get('model.registrations.confirmed');
    return statsObject[Object.keys(statsObject)[Object.keys(statsObject).length - 1]];
  }.property('model.registrations'),

  init: function() {
    var blotter = this.get('blotter');
    if(blotter) {
      this.setProperties({
        'blotterMesg': blotter.message,
        'blotterLink': blotter.link,
        'blotterMesgFix': blotter.message
      });
    }

    this._super();
  },

  graphOptions: [],
  graphData: function() {
    var data = this.get('model'),
        labels = Object.keys(data["registrations"]["total"]),
        confirmed = [],
        total = [];

    labels.forEach(function(key) {
      confirmed.push(data["registrations"]["confirmed"][key]);
      total.push(data["registrations"]["total"][key]);
    });

    return {
      labels: Object.keys(this.get('model')["registrations"]["total"]),
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
    };
  }.property('model'),


  actions: {
    deploy: function() {
      this.set('hasDeployed', false);
      Ember.$.post("/kotodama/deploy", function() {
        this.set('hasDeployed', true);
      });
    },

    publishUpdate: function() {
      Ember.$.post("/kotodama/publish_update");
    },

    resetBreakCounter: function() {
      Ember.$.post("/kotodama/reset_break_counter");
    },

    reload: function() {
      window.location.reload();
    },

    saveBlotter: function() {
      var self = this,
          query = "?icon=fa-exclamation-circle";

      query += "&message="+encodeURIComponent(this.get('blotterMesg'));
      query += "&link="+encodeURIComponent(this.get('blotterLink'));

      Ember.$.get("/kotodama/blotter_set"+query, function() {
        self.setProperties({
          hasBlotter: true,
          blotterMesgFix: self.get('blotterMesg')
        });
      });
    },

    clearBlotter: function() {
      var self = this;
      Ember.$.get("/kotodama/blotter_clear", function() {
        self.setProperties({
          hasBlotter: false,
          blotterMesg: "",
          blotterLink: ""
        });
      });
    },

    toggleNonMal: function() {
      this.toggleProperty('showNonMal');
    }
  }
});

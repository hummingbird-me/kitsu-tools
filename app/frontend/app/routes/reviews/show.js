import Ember from 'ember';
import ajax from 'ic-ajax';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend({
  model: function(params) {
    return this.store.find('review', params.review_id);
  },

  afterModel: function(resolvedModel) {
    return setTitle(this.modelFor('anime').get('displayTitle') + " Review by " + resolvedModel.get('user.username'));
  },

  actions: {
    upvote: function() {
      if (this.currentModel.get('liked') === "true") {
        this.send("unvote");
        return;
      }
      this.currentModel.set('liked', "true");
      return ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "up"
        }
      }).then(Ember.K, function() {
        return alert("Couldn't recommend review, something went wrong.");
      });
    },

    downvote: function() {
      if (this.currentModel.get('liked') === "false") {
        this.send("unvote");
        return;
      }
      this.currentModel.set('liked', "false");
      return ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "down"
        }
      }).then(Ember.K, function() {
        return alert("Couldn't downvote review, something went wrong.");
      });
    },

    unvote: function() {
      this.currentModel.set('liked', null);
      return ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "remove"
        }
      }).then(Ember.K, function() {
        return alert("Couldn't vote on review, something went wrong.");
      });
    }
  }
});

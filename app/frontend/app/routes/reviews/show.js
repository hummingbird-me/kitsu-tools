import Ember from 'ember';
import ajax from 'ic-ajax';
import setTitle from '../../utils/set-title';

function updateVotes(model) {
  return function(response) {
    model.set('positiveVotes', response.positive_votes);
    model.set('totalVotes', response.total_votes);
  };
}

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
      ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "up"
        }
      }).then(updateVotes(this.currentModel), function() {
        alert("Couldn't recommend review, something went wrong.");
      });
    },

    downvote: function() {
      if (this.currentModel.get('liked') === "false") {
        this.send("unvote");
        return;
      }
      this.currentModel.set('liked', "false");
      ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "down"
        }
      }).then(updateVotes(this.currentModel), function() {
        alert("Couldn't downvote review, something went wrong.");
      });
    },

    unvote: function() {
      this.currentModel.set('liked', null);
      ajax({
        url: "/reviews/" + this.currentModel.get('id') + "/vote",
        type: "POST",
        data: {
          type: "remove"
        }
      }).then(updateVotes(this.currentModel), function() {
        alert("Couldn't vote on review, something went wrong.");
      });
    }
  }
});

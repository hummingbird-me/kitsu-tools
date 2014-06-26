Hummingbird.ReviewsShowRoute = Ember.Route.extend({

  model: function(params) {
    return this.store.find('review', params.review_id);
  },

  afterModel: function(resolvedModel) {
    Ember.run.next(function() { return window.scrollTo(0, 0); });
    return Hummingbird.TitleManager.setTitle(this.modelFor('anime').get('displayTitle') + " Review by " + resolvedModel.get('user.username'));
  },

  actions: {
    upvote: function() {
      if (this.currentModel.get('liked') === "true") {
        this.send("unvote");
        return;
      }
      this.currentModel.set('liked', "true");
      return ic.ajax({
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
      return ic.ajax({
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
      return ic.ajax({
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
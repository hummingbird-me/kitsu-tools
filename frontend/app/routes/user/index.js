import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('story', {
      user_id: this.modelFor('user').get('id'),
      page: page
    });
  },

  setupController: function(controller, model) {
    var thisUserId = this.modelFor('user').get('id');
    controller.set('userInfo', this.store.find('userInfo', thisUserId));

    this.setCanLoadMore(true);
    controller.set('canLoadMore', true);
    controller.set('model', model);

    this.loadNextPage();
  },

  afterModel: function() {
    return setTitle(this.modelFor('user').get('username') + "'s Profile");
  },

  actions: {
    postComment: function(post) {
      if (post.comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

      var story = this.store.createRecord('story', {
        type: 'comment',
        poster: this.get('currentUser.model.content'),
        user: this.modelFor('user'),
        comment: post.comment,
        adult: post.isAdult
      });
      this.currentModel.unshiftObject(story);
      story.save();
    }
  }
});

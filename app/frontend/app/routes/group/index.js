import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';

export default Ember.Route.extend(Paginated, {
  fetchPage: function(page) {
    return this.store.find('story', {
      group_id: this.modelFor('group').get('id'),
      page: page
    });
  },

  setupController: function(controller, model) {
    setTitle(controller.get('group.name'));

    var groups = this.store.find('group', {
      limit: 3
    });
    controller.set('suggestedGroups', groups);

    this.setCanLoadMore(true);
    controller.setProperties({
      'canLoadMore': true,
      'model': model
    });
    this.loadNextPage();
  },

  actions: {
    postComment: function(post) {
      if (post.comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

      var story = this.store.createRecord('story', {
        type: 'comment',
        group: this.modelFor('group'),
        user: this.get('currentUser.model.content'),
        poster: this.get('currentUser.model.content'),
        comment: post.comment,
        adult: post.isAdult
      });
      this.currentModel.unshiftObject(story);
      story.save();
    }
  }
});

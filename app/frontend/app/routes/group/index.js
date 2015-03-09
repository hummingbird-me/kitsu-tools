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
      trending: true,
      limit: 3
    });
    var users = this.store.find('group-member', {
      group_id: this.modelFor('group').get('id'),
      recent: true
    });

    this.setCanLoadMore(true);
    controller.setProperties({
      'suggestedGroups': groups,
      'recentMembers': users,
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

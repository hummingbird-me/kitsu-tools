import Ember from 'ember';
import Paginated from '../../mixins/paginated';
import setTitle from '../../utils/set-title';
/* global Messenger */

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
    controller.set('canLoadMore', true);
    controller.set('model', model);
    this.loadNextPage();
  },

  actions: {
    postComment: function(comment) {
      if (comment.replace(/\s/g, '').replace(/\[[a-z]+\](.?)\[\/[a-z]+\]/i, '$1').length === 0) {
        return;
      }

      // permission check
      if (!this.modelFor('group').isMember(this.get('currentUser'))) {
        Messenger().error("You must be a member of the group.");
        return;
      }

      var story = this.store.createRecord('story', {
        type: 'comment',
        group: this.modelFor('group'),
        user: this.get('currentUser.model.content'),
        poster: this.get('currentUser.model.content'),
        comment: comment
      });
      this.currentModel.unshiftObject(story);
      story.save();
    }
  }
});

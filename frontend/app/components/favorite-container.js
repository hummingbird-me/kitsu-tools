import Ember from 'ember';
import ajax from 'ic-ajax';

var FAVS_PER_PAGE = 6;

export default Ember.Component.extend({
  store: Ember.computed.alias('targetObject.store'),

  isAnimeContainer: Ember.computed.equal('containerType', 'anime'),
  isMangaContainer: Ember.computed.equal('containerType', 'manga'),

  isEditing: false,
  isLoading: true,
  showPages: 1,

  showAnimeFavorites: Ember.computed.or('viewingSelf', 'favoriteListCapped.length', 'isAnimeContainer'),


  favoriteList: function() {
    this.set('isLoading', false);
    return this.get('favorites').sortBy('favRank');
  }.property('favorites.@each' ,'isEditing'),

  favoriteListCapped: function(){
    if(this.get('isEditing')) { return this.get('favoriteList'); }

    var favs = this.get('favoriteList'),
        page = this.get('showPages');

    return favs.slice(0, page * FAVS_PER_PAGE);
  }.property('favorites.@each', 'showPages', 'isEditing'),

  canLoadMoreFavorites: function () {
    var page = this.get('showPages');
    return (page * FAVS_PER_PAGE + 1 <= this.get('favoriteList.length'));
  }.property('favoriteList.@each', 'showPages'),

  disabled: function() {
    return !this.get('isEditing');
  }.property('isEditing'),

  editable: function() {
    var self = this;

    if(this.get('isEditing')) {
      this.$('.media-grid-dragsort').dragsort({
        dragSelector: ".grid-draggable",
        dragEnd: function() {
          self.$('.media-grid-dragsort').children('li').each(function(i, fav) {
            var id = self.$(fav).attr('data-id');
            self.get('targetObject.store').find('favorite', id).then(function(item) {
              item.set('favRank', i);
            });
          });
        }
      });
    } else {
      // Manual workaround for broken part in vendor script
      // this.$().dragsort('destroy');
      this.$('.media-grid-dragsort').unbind("mousedown")
              .children().unbind("mousedown")
                         .unbind("dragsort-uninit");
    }
  }.observes('isEditing'),

  viewingSelf: function(){
    return (this.get('user.id') === this.get('currentUser.id'));
  }.property('user.id', 'currentUser.id'),


  actions: {
    deleteFavorite: function(fav) {
      this.get('targetObject.store').find('favorite', fav.id).then(function(item) {
        item.destroyRecord();
      });
    },

    loadMoreFavorites: function () {
      var page = this.get('showPages');
      if (page * FAVS_PER_PAGE + 1 <= this.get('favoriteList.length')) {
        this.set('showPages', (page + 1));
      }
    },

    editFavorites: function(){
      this.set('isEditing', true);
    },

    saveFavoritePositions: function () {
      this.set('isEditing', false);
      this.get('targetObject.store').filter('favorite', function(fav) {
        return fav.get('isDirty') === true;
      }).then(function(updatedFavs) {
        if(updatedFavs.get('length') === 0) {
          return;
        }

        var postData = updatedFavs.map(function(fav) {
          return {
            id: fav.get('id'),
            rank: fav.get('favRank')
          };
        });

        return ajax({
          type: 'POST',
          url: "/favorites/update_all",
          data: { favorites: JSON.stringify(postData) },
          dataType: 'json'
        }).then(Ember.K, function() {
          alert("Something went wrong.");
        });

      });
    },

    pushFavorite: function(fav) {
      this.get('favorites').pushObject(fav);
    }
  }
});

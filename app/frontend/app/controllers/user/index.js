import Ember from 'ember';
import ajax from 'ic-ajax';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.ArrayController.extend(HasCurrentUser, {
  needs: "user",
  user: Ember.computed.alias('controllers.user'),
  waifu_slug: Ember.computed.any('user.waifuSlug'),
  hasWaifu: Ember.computed.any('user.waifu'),
  hasLocation: Ember.computed.any('user.location'),
  hasWebsite: Ember.computed.any('user.website'),
  hasAboutText: Ember.computed.any('user.about'),
  hasAboutSection: Ember.computed.or(
    'hasWaifu',
    'hasLocation',
    'hasWebsite',
    'hasAboutText'
  ),

  unselectingWaifu: false,

  aboutCharacterCount: function() {
    return 500 - this.get('user.about').length;
  }.property('user.about'),

  aboutCharactersLeft: Ember.computed.gt('aboutCharacterCount', 0),

  sortProperties: ['createdAt'],
  sortAscending: false,

  isEditing: false,
  editingFavorites: false,
  selectChoices: ["Waifu", "Husbando"],
  selectedWaifu: null,
  favorite_anime_page: 1,
  favorite_manga_page: 1,

  linkedWebsites: function(){
    if (!this.get("hasWebsite")) {
      return;
    }

    var dataList = this.get('user.website').split(' '),
        siteList = [],
        actualLn = "";

    dataList.forEach(function(link){
      actualLn = (/[a-z]{4,}\:\/\//.test(link)) ? link.trim() : 'http://'+link.trim();
      siteList.push({'link': actualLn, 'name': link.trim()});
    });

    return siteList;
  }.property('user.website'),

  favorite_anime_list: function() {
    var anime = this.get('favorite_anime_data'),
        page  = this.get('favorite_anime_page');

    return anime.slice(0, page * 6);
  }.property('favorite_anime_data.length', 'favorite_anime_page'),

  favorite_manga_list: function() {
    var manga = this.get('favorite_manga_data'),
        page  = this.get('favorite_manga_page');

    return manga.slice(0, page * 6);
  }.property('favorite_manga_data.length', 'favorite_manga_page'),

  favorite_anime_load_more: function () {
    var page = this.get('favorite_anime_page');
    return (page * 6 + 1 <= this.get('favorite_anime_data.length'));
  }.property('favorite_anime_data.length', 'favorite_anime_page'),

  favorite_manga_load_more: function () {
    var page = this.get('favorite_manga_page');
    return (page * 6 + 1 <= this.get('favorite_manga_data.length'));
  }.property('favorite_manga_data.length', 'favorite_manga_page'),

  favorite_anime_data: function(){
    return this.favorite_data("Anime");
  }.property(),

  favorite_manga_data: function(){
    return this.favorite_data("Manga");
  }.property(),

  favorite_data: function(item_type){
    var self = this;

    return this.store.find('favorite', {
      user_id: self.get('user.id'),
      type: item_type
    });
  },


  actions: {
    unselectWaifu: function () {
      this.set('unselectingWaifu', true);
      return this.set('user.waifu', null);
    },

    editUserInfo: function () {
      return this.set('isEditing', true);
    },

    saveUserInfo: function () {
      this.set('unselectingWaifu', false);
      this.get('user.content').save();
      return this.set('isEditing', false);
    },

    editFav: function () {
      return this.set('editingFavorites', true);
    },

    doneEditingFav: function () {
      this.set('editingFavorites', false);

      this.store.filter('favorite', function(fav){
        return fav.get('isDirty') === true;
      }).then(function(updatedFavs){
        if(updatedFavs.get('length') === 0){
          return;
        }

        var postData = updatedFavs.map(function(fav){
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

    didSelectWaifu: function (character) {
      this.set('selectedWaifu', character);
      this.get('user').set('waifu', character.value);
      return this.get('user').set('waifuCharId', character.char_id);
    },

    favoriteAnimeLoadMore: function () {
      var page = this.get('favorite_anime_page');
      if (page * 6 + 1 <= this.get('favorite_anime').length) {
        ++page;
        return this.set('favorite_anime_page', page);
      }
    },

    favoriteMangaLoadMore: function () {
      var page = this.get('favorite_manga_page');
      if (page * 6 + 1 <= this.get('favorite_manga').length) {
        ++page;
        return this.set('favorite_manga_page', page);
      }
    },

    goPrevPage: function () {
      var page;
      page = this.get('favorite_anime_page');
      if (page > 1) {
        --page;
        return this.set('favorite_anime_page', page);
      }
    },

    goNextPage: function () {
      var page;
      page = this.get('favorite_anime_page');
      if (page * 6 + 1 <= this.get('favorite_anime').length) {
        ++page;
        return this.set('favorite_anime_page', page);
      }
    },
  },

  animeBreakdown: function(){
    var topGenres = this.get('userInfo.topGenres');

    if (topGenres && topGenres.length > 0) {
      return [
        {value: parseInt(topGenres[0]['num']), color: "#ec8661"},
        {value: this.get('userInfo.animeWatched') - parseInt(topGenres[0]['num']), color: "#f7cab9"}
      ];
    } else {
      return [];
    }
  }.property('userInfo.topGenres'),

  animeOptions: function(){
    return {
      percentageInnerCutout : 75,
      segmentShowStroke : false,
      segmentStrokeWidth : 0,
      animation : false
    };
  }.property(),

  lifeSpentOnAnimeFmt: function () {
    var days, hours, minutes, months, str, years;
    minutes = this.get('userInfo.lifeSpentOnAnime');

    if (minutes === 0) { return "0 minutes"; }

    years = months = days = hours = 0;
    hours = Math.floor(minutes / 60);
    minutes = minutes % 60;
    days = Math.floor(hours / 24);
    hours = hours % 24;
    months = Math.floor(days / 30);
    days = days % 30;
    years = Math.floor(months / 12);
    months = months % 12;

    str = "";
    if (years > 0) {
      str += years + " " + (years === 1 ? "year" : "years");
    }
    if (months > 0) {
      if (str.length > 0) {
        str += ", ";
      }
      str += months + " " + (months === 1 ? "month" : "months");
    }
    if (days > 0) {
      if (str.length > 0) {
        str += ", ";
      }
      str += days + " " + (days === 1 ? "day" : "days");
    }
    if (hours > 0) {
      if (str.length > 0) {
        str += ", ";
      }
      str += hours + " " + (hours === 1 ? "hour" : "hours");
    }
    if (minutes > 0) {
      if (str.length > 0) {
        str += " and ";
      }
      str += minutes + " " + (minutes === 1 ? "minute" : "minutes");
    }

    return str;
  }.property('userInfo.lifeSpentOnAnime'),

  viewingSelf: function () {
    return this.get('controllers.user.id') === this.get('currentUser.id');
  }.property('model.id')
});

import Ember from 'ember';
import HasCurrentUser from '../../mixins/has-current-user';

export default Ember.ArrayController.extend(HasCurrentUser, {
  needs: "user",
  user: Ember.computed.alias('controllers.user'),
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
  waifuPath: function() {
    return '/characters/' + this.get('user.waifu.id');
  }.property('user.waifu.id'),

  aboutCharacterCount: function() {
    return 500 - this.get('user.about').length;
  }.property('user.about'),

  aboutCharactersLeft: Ember.computed.gt('aboutCharacterCount', 0),

  sortProperties: ['createdAt'],
  sortAscending: false,

  isEditing: false,
  selectChoices: ["Waifu", "Husbando"],
  selectedWaifu: null,

  linkedWebsites: function() {
    if (!this.get("hasWebsite")) {
      return;
    }

    var dataList = this.get('user.website').split(' '),
        siteList = [],
        actualLn = "";

    dataList.forEach(function(link) {
      actualLn = (/[a-z]{4,}\:\/\//.test(link)) ? link.trim() : 'http://'+link.trim();
      siteList.push({'link': actualLn, 'name': link.trim()});
    });

    return siteList;
  }.property('user.website'),

  favoriteAnime: function() {
    if(this.get('userInfo.favorites') === undefined) { return []; }

    this.set('favoriteAnimeLoading', false);
    return this.get('userInfo.favorites').filter(function(fav){
      return ( fav.get('item').constructor.typeKey === 'anime');
    });
  }.property('userInfo.favorites.@each'),

  favoriteManga: function() {
    if(this.get('userInfo.favorites') === undefined) { return []; }

    this.set('favoriteMangaLoading', false);
    return this.get('userInfo.favorites').filter(function(fav){
      return ( fav.get('item').constructor.typeKey === 'manga');
    });
  }.property('userInfo.favorites.@each'),


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

    didSelectWaifu: function (character) {
      this.set('selectedWaifu', character);
      return this.get('user').set('waifu', character.char_id);
    }
  },

  animeBreakdown: function() {
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

  animeOptions: function() {
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

import Ember from 'ember';
import DS from 'ember-data';
import Media from '../models/media';
import ModelCurrentUser from '../mixins/model-current-user';
/* global moment */

export default Media.extend(ModelCurrentUser, {
  canonicalTitle: DS.attr('string'),
  englishTitle: DS.attr('string'),
  romajiTitle: DS.attr('string'),
  synopsis: DS.attr('string'),
  posterImage: DS.attr('string'),
  posterImageThumb: DS.attr('string'),
  showType: DS.attr('string'),
  ageRating: DS.attr('string'),
  ageRatingGuide: DS.attr('string'),
  episodeCount: DS.attr('number'),
  episodeLength: DS.attr('number'),
  startedAiring: DS.attr('date'),
  startedAiringDateKnown: DS.attr('boolean'),
  finishedAiring: DS.attr('date'),
  genres: DS.attr('array'),
  libraryEntry: DS.belongsTo('library-entry'),

  nsfw: function() {
    return this.get('ageRating') === "R18+" || this.get('ageRating') === "R17+";
  }.property('ageRating'),

  displayTitle: function() {
    var currentUser, pref, title;
    currentUser = this.get('currentUser');
    title = this.get('canonicalTitle');
    if (currentUser.get('isSignedIn')) {
      pref = currentUser.get('titleLanguagePreference');
      if (pref === "english" && this.get('englishTitle') && this.get('englishTitle').length > 0) {
        title = this.get('englishTitle');
      } else if (pref === "romanized" && this.get('romajiTitle') && this.get('romajiTitle').length > 0) {
        title = this.get('romajiTitle');
      }
    }
    return title;
  }.property('canonicalTitle', 'englishTitle', 'romajiTitle'),

  lowercaseDisplayTitle: function() {
    return this.get('displayTitle').toLowerCase();
  }.property('canonicalTitle'),

  searchString: function() {
    var str = this.get('canonicalTitle');
    if (this.get('englishTitle') && this.get('englishTitle').length > 0) {
      str += this.get('englishTitle');
    }
    if (this.get('romajiTitle') && this.get('romajiTitle').length > 0) {
      str += this.get('romajiTitle');
    }
    return str.toLowerCase();
  }.property('canonicalTitle', 'englishTitle', 'romajiTitle'),

  displayEpisodeCount: function() {
    var e = this.get('episodeCount');
    return (e) ? e : "?";
  }.property('episodeCount'),

  airingStatus: function() {
    var now = Date.now();

    if (!this.get('startedAiring')) { return "Not Yet Aired"; }
    if (this.get('startedAiring') > now) { return "Not Yet Aired"; }
    if (this.get('episodeCount') === 1) { return "Finished Airing"; }
    if (this.get('finishedAiring') && this.get('finishedAiring') < now) {
      return "Finished Airing";
    }

    return "Currently Airing";
  }.property('startedAiring', 'finishedAiring', 'episodeCount'),

  notYetAired: Ember.computed.equal('airingStatus', 'Not Yet Aired'),

  formattedAirDates: function() {
    var format, formattedFinishedAiring, formattedStartedAiring, result;

    if (this.get('startedAiring')) {
      format = this.get('startedAiringDateKnown') ? "D MMM YYYY" : "MMM YYYY";
      formattedStartedAiring = moment(this.get('startedAiring')).format(format);
    } else {
      formattedStartedAiring = "?";
    }
    if (this.get('finishedAiring')) {
      formattedFinishedAiring = moment(this.get('finishedAiring')).format("D MMM YYYY");
    } else {
      formattedFinishedAiring = "?";
    }
    if (this.get('airingStatus') === "Finished Airing") {
      result = "Aired";
    } else if (this.get('airingStatus') === "Currently Airing") {
      result = "Airing";
    } else {
      result = "Will air";
    }
    if ((this.get('episodeCount') && this.get('episodeCount') === 1) || (formattedStartedAiring === formattedFinishedAiring && formattedStartedAiring !== "?")) {
      result += " on " + formattedStartedAiring;
    } else {
      result += " from " + formattedStartedAiring;
      if (formattedFinishedAiring !== "?") {
        result += " to " + formattedFinishedAiring;
      }
    }
    return result;
  }.property('startedAiring', 'finishedAiring')
});

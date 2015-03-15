// TODO: this needs to be cleaned up.

import Ember from 'ember';
import DS from 'ember-data';
import Media from '../models/media';

export default Media.extend({
  romajiTitle: DS.attr("string"),
  englishTitle: DS.attr("string"),
  posterImage: DS.attr("string"),
  synopsis: DS.attr("string"),
  mangaType: DS.attr("string"),
  volumeCount: DS.attr("number"),
  chapterCount: DS.attr("number"),
  genres: DS.attr("array"),
  mangaLibraryEntry: DS.belongsTo("manga-library-entry"),
  displayTitle: Ember.computed.alias('romajiTitle'),
  lowercaseDisplayTitle: (function() {
    return this.get("displayTitle").toLowerCase();
  }).property("englishTitle", "romajiTitle"),
  searchString: (function() {
    var str;
    str = void 0;
    str = this.get("englishTitle");
    if (this.get("englishTitle") && this.get("englishTitle").length > 0) {
      str += this.get("englishTitle");
    }
    if (this.get("romajiTitle") && this.get("romajiTitle").length > 0) {
      str += this.get("romajiTitle");
    }
    return str.toLowerCase();
  }).property("englishTitle", "romajiTitle"),
  displayChapterCount: (function() {
    var e;
    e = void 0;
    e = this.get("chapterCount");
    if (e) {
      return e;
    } else {
      return "?";
    }
  }).property("chapterCount"),
  displayVolumeCount: (function() {
    var e;
    e = void 0;
    e = this.get("volumeCount");
    if (e) {
      return e;
    } else {
      return "?";
    }
  }).property("volumeCount")
});

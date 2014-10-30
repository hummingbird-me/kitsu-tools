HB.Manga = HB.Media.extend({
  romajiTitle: DS.attr("string"),
  englishTitle: DS.attr("string"),
  posterImage: DS.attr("string"),
  synopsis: DS.attr("string"),
  mangaType: DS.attr("string"),
  volumeCount: DS.attr("number"),
  chapterCount: DS.attr("number"),
  genres: DS.attr("array"),
  mangaLibraryEntry: DS.belongsTo("mangaLibraryEntry"),
  displayTitle: (function() {
    // HACK! No way right now to inject the current user into models.
    var currentUser, pref, title;
    currentUser = void 0;
    pref = void 0;
    title = void 0;
    currentUser = HB.__container__.lookup("controller:currentUser");
    title = this.get("romajiTitle");
    if (title === null) {
      title = this.get("englishTitle");
    }
    if (currentUser.get("isSignedIn")) {
      pref = currentUser.get("titleLanguagePreference");
      if (pref === "english" && this.get("englishTitle") && this.get("englishTitle").length > 0) {
        title = this.get("englishTitle");
      } else {
        if (pref === "romanized" && this.get("romajiTitle") && this.get("romajiTitle").length > 0) {
          title = this.get("romajiTitle");
        }
      }
    }
    return title;
  }).property("englishTitle", "romajiTitle"),
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

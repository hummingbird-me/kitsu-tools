import Ember from 'ember';

const DEBOUNCE = 400; // milliseconds
const {
  Controller,
  computed: { alias },
  set,
  run
} = Ember;

export default Controller.extend({
  queryParams: [
    'ageRating', 'averageRating', 'episodeCount', 'genres',
    'streamers', 'text', 'year'
  ],
  ageRating: ['G', 'PG'],
  averageRating: [0.5, 5.0],
  episodeCount: [1, 500],
  genres: [],
  streamers: ['netflix', 'hulu', 'crunchyroll'],
  text: undefined,
  year: [1914, 2016],

  availableStreamers: [
    {key: 'netflix', icon: 'netflix'},
    {key: 'hulu', icon: 'hulu', },
    {key: 'crunchyroll', icon: 'crunchyroll'},
    {key: 'funimation', icon: 'funimation'},
    {key: 'daisuki', icon: 'daisuki'}
  ],
  availableAgeRatings: [
    {key: 'G', label: 'G'},
    {key: 'PG', label: 'PG'},
    {key: 'R', label: 'R'},
    {key: 'R18', label: 'R18'}
  ],
  availableGenres: [
    {key: "Action", linkLabel: "Action"},
    {key: "Adventure", linkLabel: "Adventure"},
    {key: "Comedy", linkLabel: "Comedy"},
    {key: "Drama", linkLabel: "Drama"},
    {key: "Sci-Fi", linkLabel: "Sci-Fi"},
    {key: "Space", linkLabel: "Space"},
    {key: "Mystery", linkLabel: "Mystery"},
    {key: "Magic", linkLabel: "Magic"},
    {key: "Supernatural", linkLabel: "Supernatural"},
    {key: "Police", linkLabel: "Police"},
    {key: "Fantasy", linkLabel: "Fantasy"},
    {key: "Sports", linkLabel: "Sports"},
    {key: "Romance", linkLabel: "Romance"},
    {key: "Slice of Life", linkLabel: "Slice of Life"},
    {key: "Cars", linkLabel: "Cars"},
    {key: "Horror", linkLabel: "Horror"},
    {key: "Psychological", linkLabel: "Psychological"},
    {key: "Thriller", linkLabel: "Thriller"},
    {key: "Martial Arts", linkLabel: "Martial Arts"},
    {key: "Super Power", linkLabel: "Super Power"},
    {key: "School", linkLabel: "School"},
    {key: "Ecchi", linkLabel: "Ecchi"},
    {key: "Vampire", linkLabel: "Vampire"},
    {key: "Historical", linkLabel: "Historical"},
    {key: "Military", linkLabel: "Military"},
    {key: "Dementia", linkLabel: "Dementia"},
    {key: "Mecha", linkLabel: "Mecha"},
    {key: "Demons", linkLabel: "Demons"},
    {key: "Samurai", linkLabel: "Samurai"},
    {key: "Harem", linkLabel: "Harem"},
    {key: "Music", linkLabel: "Music"},
    {key: "Parody", linkLabel: "Parody"},
    {key: "Shoujo Ai", linkLabel: "Shoujo Ai"},
    {key: "Game", linkLabel: "Game"},
    {key: "Shounen Ai", linkLabel: "Shounen Ai"},
    {key: "Kids", linkLabel: "Kids"},
    {key: "Hentai", linkLabel: "Hentai"},
    {key: "Yuri", linkLabel: "Yuri"},
    {key: "Yaoi", linkLabel: "Yaoi"},
    {key: "Anime Influenced", linkLabel: "Anime Influenced"}
  ],

  media: alias('model'),

  _setText: function(text) {
    set(this, 'text', text);
  },

  actions: {
    filterText(query) {
      run.debounce(this, '_setText', query, DEBOUNCE);
    },

    reload() {
      this.send('refreshModel');
    },
  }
});

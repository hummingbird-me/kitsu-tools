import Ember from 'ember';

const {
  Controller,
  computed,
  computed: { alias },
  set,
  get,
  run
} = Ember;

const DEBOUNCE = 200; // milliseconds

export default Controller.extend({
  queryParams: [
    'text', 'year', 'averageRating', 'streamers', 'ageRating', 'episodeCount',
    'genres'
  ],
  text: undefined,
  year: '1914..2016',
  averageRating: '0.5..5.0',
  episodeCount: '1..500',
  streamers: 'netflix,hulu,crunchyroll',
  ageRating: 'G,PG',
  genres: '',

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

  years: computed('year', function () {
    return get(this, 'year').split('..').map((i) => parseInt(i, 10));
  }),
  episodeCountArray: computed('episodeCount', function () {
    return get(this, 'episodeCount').split('..').map((i) => parseInt(i, 10));
  }),
  ratings: computed('averageRating', function () {
    return get(this, 'averageRating').split('..').map((i) => parseFloat(i));
  }),
  ageRatingsArray: computed('ageRating', function () {
    return get(this, 'ageRating').split(',');
  }),
  streamersArray: computed('streamers', function () {
    return get(this, 'streamers').split(',');
  }),
  genresArray: computed('genres', function () {
    return get(this, 'genres').split(',');
  }),

  media: alias('model'),

  actions: {
    filterText(query) {
      // TODO: Debounce?
      set(this, 'text', query);
    },
    setRange(prop, range) {
      set(this, prop, range.join('..'));
    },
    setRangeAndReload(prop, range) {
      set(this, prop, range.join('..'));
      this.send('refreshModel');
    },
    setArray(prop, array) {
      set(this, prop, array.join(','));
    }
  }
});

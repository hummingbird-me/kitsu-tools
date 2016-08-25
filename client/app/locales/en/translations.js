/**
 * Translation file for English.
 */
export default {
  // Static page titles. Keys must match the route name
  titles: {
    anime: {
      index: 'Explore Anime'
    },
    dashboard: 'Dashboard',
    'not-found': '404',
    onboarding: {
      start: 'Onboarding Start'
    },
    'server-error': '500',
    'sign-in': 'Sign In',
    'sign-up': 'Sign Up',
    users: {
      index: '{{user}}\'s Profile',
      library: '{{user}}\'s Library',
      lists: '{{user}}\'s List',
      reviews: '{{user}}\'s Reviews'
    }
  },
  // Text for links
  links: {
    auth: {
      'sign-up': 'Sign Up',
      'sign-in': 'Sign In',
      logout: 'Logout'
    }
  },
  media: {
    anime: {
      name: 'Anime',
      'show-type': {
        TV: 'TV',
        special: 'Special',
        ONA: 'OVA',
        OVA: 'ONA',
        movie: 'Movie',
        music: 'Music'
      }
    },
    manga: {
      name: 'Manga',
      'manga-type': {
        manga: 'Manga',
        novel: 'Novel',
        manhua: 'Manhua',
        oneshot: 'One-shot',
        doujin: 'Doujin'
      }
    },
    drama: {
      name: 'Drama',
      'show-type': {
        drama: 'Drama',
        movie: 'Movie',
        special: 'Drama Special'
      }
    },
    routes: {
      index: {
        filter: {
          year: 'Year',
          score: 'Score',
          streamers: 'Streamers (U.S.)',
          episodes: 'Episodes',
          rating: 'Rating',
          genres: 'Categories',
          search: 'Search by title, director, studio, or voice actor'
        }
      }
    }
  },
  library: {
    remove: 'Remove from Library',
    statuses: {
      anime: {
        all: 'All',
        current: 'Currently Watching',
        planned: 'Plan To Watch',
        completed: 'Completed',
        on_hold: 'On Hold',
        dropped: 'Dropped'
      },
      manga: {
        all: 'All',
        current: 'Currently Reading',
        planned: 'Plan To Read',
        completed: 'Completed',
        on_hold: 'On Hold',
        dropped: 'Dropped'
      },
      drama: {
        all: 'All',
        current: 'Currently Watching',
        planned: 'Plan To Watch',
        completed: 'Completed',
        on_hold: 'On Hold',
        dropped: 'Dropped'
      }
    }
  },
  // Global header
  header: {
    shows: 'Shows',
    forums: 'Forums',
    downloads: 'Downloads',
    user: {
      profile: 'View Profile'
    }
  },
  // Global footer
  footer: {
    header: 'Find an anime, manga, or drama',
    'search-placeholder': 'Search by title...'
  },
  // Sign in route text
  'sign-in': {
    header: 'Sign in to Hummingbird',
    identification: 'Email or Username',
    password: 'Password',
    'no-account': 'Don\'t have an account yet?'
  },
  // Sign up route text
  'sign-up': {
    header: 'Sign up for Hummingbird',
    username: 'Username',
    email: 'Email',
    password: 'Password',
    'has-account': 'Already have an account?'
  },
  // Users route text
  users: {
    following: 'Following',
    followers: 'Followers',
    follow: 'Follow',
    nav: {
      activity: 'Activity',
      library: 'Library',
      reviews: 'Reviews',
      lists: 'Lists'
    },
    library: {
      library: '{{type}} Library',
      search: 'Search this library...',
      notes: 'Personal notes about {{title}}',
      public: 'Public',
      private: 'Private',
      rewatch: 'Rewatch',
      rewatched: 'Rewatched',
      times: 'times'
    }
  },
  errors: {
    // ember-cp-validations default errors
    description: 'This field',
    inclusion: '{{description}} is not included in the list',
    exclusion: '{{description}} is reserved',
    invalid: '{{description}} is invalid',
    confirmation: '{{description}} doesn\'t match {{on}}',
    accepted: '{{description}} must be accepted',
    empty: '{{description}} can\'t be empty',
    blank: '{{description}} can\'t be blank',
    present: '{{description}} must be blank',
    collection: '{{description}} must be a collection',
    singular: '{{description}} can\'t be a collection',
    tooLong: '{{description}} is too long (maximum is {{max}} characters)',
    tooShort: '{{description}} is too short (minimum is {{min}} characters)',
    before: '{{description}} must be before {{before}}',
    after: '{{description}} must be after {{after}}',
    wrongDateFormat: '{{description}} must be in the format of {{format}}',
    wrongLength: '{{description}} is the wrong length (should be {{is}} characters)',
    notANumber: '{{description}} must be a number',
    notAnInteger: '{{description}} must be an integer',
    greaterThan: '{{description}} must be greater than {{gt}}',
    greaterThanOrEqualTo: '{{description}} must be greater than or equal to {{gte}}',
    equalTo: '{{description}} must be equal to {{is}}',
    lessThan: '{{description}} must be less than {{lt}}',
    lessThanOrEqualTo: '{{description}} must be less than or equal to {{lte}}',
    otherThan: '{{description}} must be other than {{value}}',
    odd: '{{description}} must be odd',
    even: '{{description}} must be even',
    positive: '{{description}} must be positive',
    date: '{{description}} must be a valid date',
    email: '{{description}} must be a valid email address',
    phone: '{{description}} must be a valid phone number',
    url: '{{description}} must be a valid url',
    // Custom errors
    user: {
      name: {
        invalid: 'This field must only contain letters, numbers, and underscores',
        numbers: 'This field must not be made up of numbers entirely',
        starts: 'This field must start with a letter or number'
      }
    }
  }
};

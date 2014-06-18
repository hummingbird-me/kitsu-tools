Hummingbird.MangaLibrary = DS.Model.extend
  item: DS.belongsTo('manga')
  status: DS.attr('string')
  isFavorite: DS.attr('boolean')
  rating: DS.attr('number')
  partsConsumed: DS.attr('number')
  private: DS.attr('boolean')
  reconsuming: DS.attr('boolean')
  reconsumeCount: DS.attr('number')
  lastConsumed: DS.attr('date')
  
  positiveRating: (-> @get('rating') >= 3.6).property('rating')
  negativeRating: (-> @get('rating') <= 2.4).property('rating')
  neutralRating: (-> @get('rating') > 2.4 and @get('rating') < 3.6).property('rating')

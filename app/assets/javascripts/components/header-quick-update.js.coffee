Hummingbird.HeaderQuickUpdateComponent = Ember.Component.extend
  tagNames: "li"
  classNames: "watched-series"

  actions:
    incCnt: ->
      item = @get('item')
      epsWatched = item.get('episodesWatched')
      eps = @get('item.anime.episodeCount')

      if (epsWatched < eps || !eps)
        item.set('episodesWatched', epsWatched + 1)
        item.save()
        
 
  imageUrl: (->
    item = @get('item')
    if item
      return item.get('anime.posterImage')
  ).property('item.anime')

  episodesWatchedStats: (->
    epsWatched = @get('item.episodesWatched')
    eps = @get('item.anime.episodeCount')
    if eps
      return Math.ceil( (epsWatched / eps) * 100)
    else return "--"
  ).property('item.anime', 'item')
 
  episodeCount: (->
    count = @get('item.anime.episodeCount')
    if count
      return count
    else return "?"
  ).property('item.anime')
  
  incrementLabel: (->
    epsWatched = @get('item.episodesWatched')
    eps = @get('item.anime.episodeCount')
    completed = @get('seriesIsCompleted')
    if !completed
      return (epsWatched + 1)
    else return ""
  ).property('item.anime', 'item')

  seriesIsCompleted: (->
    epsWatched = @get('item.episodesWatched')
    eps = @get('item.anime.episodeCount')
    if eps == epsWatched
      return true
    else return false
  ).property('item.anime', 'item')

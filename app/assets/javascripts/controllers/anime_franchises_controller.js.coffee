Hummingbird.AnimeFranchisesController = Ember.ArrayController.extend
  franchiseAnime: (->
    anime = []
    @get('content.@each.anime').forEach (fa) ->
      anime = anime.concat fa.toArray()
    Ember.ArrayProxy.createWithMixins Ember.SortableMixin,
      content: anime.uniq()
      sortProperties: ['startedAiring', 'finishedAiring']
      sortFunction: (x, y) ->
        if Ember.isNone(x) and Ember.isNone(y)
          0
        else if Ember.isNone(x)
          1
        else if Ember.isNone(y)
          -1
        else
          Ember.compare(x, y)
  ).property('@each.anime')

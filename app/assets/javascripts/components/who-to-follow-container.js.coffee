Hummingbird.WhoToFollowContainerComponent = Em.Component.extend
  filteredLength: null
  filteredArray: (->
    users = @get('usersToFollow')
    _this = @
    if users
      filtered = users.filter((user)->
        return (user.get('id') != _this.get('currentUser.id') and user.get('isFollowed') == false)
      )
      @set('filteredLength', filtered.length)
      return filtered.slice(0,3)
    else []
  ).property('usersToFollow.@each', 'usersToFollow.@each.isFollowed')
  
  filteredLengthObserver: (->
    len = @get('filteredLength')
    if len and len < 8
      @sendAction()
  ).observes('filteredLength')

  actions:
    dismiss: (user)->
      @sendAction("dismiss", user)

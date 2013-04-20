autoLink = (options...) ->
  link_attributes = ''
  option = options[0]
  url_pattern =
    /(^|\s)(\b(https?|ftp):\/\/[\-A-Z0-9+\u0026@#\/%?=~_|!:,.;]*[\-A-Z0-9+\u0026@#\/%=~_|])/gi

  return @replace url_pattern, "$1<a href='$2'>$2</a>" unless options.length > 0

  if option['callback']? and typeof option['callback'] is 'function'
    callbackThunk = option['callback']
    delete option['callback']

  link_attributes += " #{key}='#{value}'" for key, value of option

  @replace url_pattern, (match, space, url) ->
    returnCallback = callbackThunk and callbackThunk(url)
    link = returnCallback or "<a href='#{url}'#{link_attributes}>#{url}</a>"

    "#{space}#{link}"

String.prototype['autoLink'] = autoLink

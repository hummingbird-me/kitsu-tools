Handlebars.registerHelper 'pluralize', (number, singular, plural) ->
  if number == 1
    return singular
  else
    if typeof plural == 'string'
      return plural
    else
      return singular + 's'

Handlebars.registerHelper 'pluralCount', (number, singular, plural) ->
  return number + ' ' + Handlebars.helpers.pluralize.apply(this, arguments)

Handlebars.registerHelper 'timeAgo', (t) ->
  return moment(t).fromNow()


Handlebars.registerHelper 'watchlistStatusChange', (user, new_status) ->
  return I18n.t("stories.watchlist_status_updates.third_person." + new_status + "_html", {user: "<a href='" + user.url + "'>" + user.name + "</a>"})
  

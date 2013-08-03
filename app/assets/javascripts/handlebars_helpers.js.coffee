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

Handlebars.registerHelper 'truncate', (str, len) ->
  if str.length > len
    new_str = $.trim(str).substring(0, len).split(" ").slice(0, -1).join(" ")
    if new_str.length == 0
      new_str = str.substring(0, len)
    new_str += "..."
  else
    new_str = str
  return new_str

Handlebars.registerHelper 'watchlistStatusChangeStory', (user, new_status) ->
  return I18n.t("stories.watchlist_status_updates.third_person." + new_status + "_html", {user: "<a href='" + user.url + "'>" + user.name + "</a>"})

Handlebars.registerHelper 'watchedEpisodeStory', (user, episode_number, service) ->
  extra = ""
  if service
    if service == "neon_alley"
      extra = " on <a href='http://neonalley.com/' target='_blank'>Neon Alley</a>"
  return I18n.t("stories.watched_episode_html", {user: "<a href='" + user.url + "'>" + user.name + "</a>", number: episode_number, extra: extra})
  

var storyTemplates;

Handlebars.registerHelper('pluralize', function(number, singular, plural) {
  if (number === 1) {
    return singular;
  } else {
    if (typeof plural === 'string') {
      return plural;
    } else {
      return singular + 's';
    }
  }
});

Handlebars.registerHelper('pluralCount', function(number, singular, plural) {
  return number + ' ' + Handlebars.helpers.pluralize.apply(this, arguments);
});

Handlebars.registerHelper('timeAgo', function(t) {
  return moment(t).fromNow();
});

Handlebars.registerHelper('truncate', function(str, len) {
  var new_str;
  if (str.length > len) {
    new_str = $.trim(str).substring(0, len).split(" ").slice(0, -1).join(" ");
    if (new_str.length === 0) {
      new_str = str.substring(0, len);
    }
    new_str += "...";
  } else {
    new_str = str;
  }
  return new_str;
});

storyTemplates = {
  plan_to_watch: "{{user}} plans to watch.",
  currently_watching: "{{user}} is currently watching.",
  completed: "{{user}} has completed.",
  on_hold: "{{user}} has placed on hold.",
  dropped: "{{user}} has dropped."
};

Handlebars.registerHelper('watchlistStatusChangeStory', function(user, new_status) {
  return storyTemplates[new_status].replace("{{user}}", "<a href='" + user.url + "'>" + user.name + "</a>");
});

Handlebars.registerHelper('watchedEpisodeStory', function(user, episode_number, service) {
  var extra, number;
  extra = "";
  user = "<a href='" + user.url + "'>" + user.name + "</a>";
  number = episode_number;
  return user + " watched episode " + number + extra + ".";
});
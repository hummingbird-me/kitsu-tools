module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
    page_title.to_s
  end

  def markdown(text)
    return "" if text.nil?
    sanitize(RDiscount.new(Haml::Helpers.html_escape(text)).to_html).html_safe
  end

  def percentage_completed(anime, watchlist)
    return 0 if !watchlist or !anime.episode_count

    if anime.episode_count == 0
      if watchlist.status == "Finished"
        return 100.0
      else
        return 2.0
      end
    else
      2.0 + ((watchlist.episodes_watched || 0) * 98.0 / anime.episode_count).to_i
    end
  end

  # Convert minutes into a string like "1 month, 4 days, 21 hours and 7 minutes"
  def format_minutes(minutes)
    return "0 minutes" if minutes.nil? or minutes == 0

    years, months, days, hours = 0, 0, 0, 0
    hours, minutes = minutes/60, minutes%60
    days, hours    = hours/24, hours%24
    months, days   = days/30, days%30
    years, months  = months/12, months%12

    narray = [years, months, days, hours, minutes]
    warray = %w(year month day hour minute)
    oarray = narray.zip(warray).select {|x| x[0] > 0 }
                   .map {|x| pluralize(x[0], x[1]) }

    if oarray.length == 0
      return nil
    elsif oarray.length == 1
      return oarray[0]
    else
      return (oarray[0..-2] * ', ') + " and #{oarray[-1]}"
    end
  end

  def overlay_quote_from_anime(anime)
    if anime and quote = anime.quotes.order('RANDOM()').first
      quote
    else
      Quote.includes(:anime).where("anime.age_rating <> 'R18+'").references(:anime).where('"quotes"."id" >= (SELECT RANDOM() * MAX("id") FROM "quotes")::integer').first
    end
  end

  # Linking helpers
  def avatar_link(user, style=:thumb)
    link_to image_tag(user.avatar.url(style)), main_app.user_path(user), alt: "#{user.name}'s avatar"
  end
  def user_link(user, options={})
    link_to (user == current_user and options[:you]) ? "You" : user.name, user
  end
  def anime_link(anime, options={})
    link_to anime.canonical_title(current_user), anime, options
  end

  # For Devise
  def resource_name
    :user
  end
  def resource
    @resource ||= User.new
  end
  def resource_class
    User
  end
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  def omniauth_authorize_path(resource_name, provider)
    "/users/auth/#{provider.to_s}"
  end

  def short_time_ago(time)
    difference_in_seconds = Time.now.to_i - time.to_i
    if difference_in_seconds < 60
      return pluralize(difference_in_seconds, "second")
    end
    
    difference_in_minutes = difference_in_seconds / 60
    if difference_in_minutes < 60
      return pluralize(difference_in_minutes, "minute")
    end
    
    difference_in_hours = difference_in_minutes / 60
    if difference_in_hours < 24
      return pluralize(difference_in_hours, "hour")
    end

    difference_in_days = difference_in_hours / 24
    if difference_in_days < 30
      return pluralize(difference_in_days, "day")
    end
    
    difference_in_months = difference_in_days / 30
    if difference_in_months < 12
      return pluralize(difference_in_months, "month")
    end
    
    difference_in_years = difference_in_days / 365
    return pluralize(difference_in_years, "year")
  end
end

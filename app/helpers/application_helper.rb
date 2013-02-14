module ApplicationHelper
  def title(page_title)
    content_for(:title, page_title.to_s)
    page_title.to_s
  end

  def percentage_completed(anime, watchlist)
    if watchlist
      ((watchlist.episodes_watched+1) * 100.0 / (anime.episode_count+1)).to_i
    else
      0
    end
  end

  # Convert minutes into a string like "1 month, 4 days, 21 hours and 7 minutes"
  def format_minutes(minutes)
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
end

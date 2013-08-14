module AnimesHelper
  def airing_date(anime)
    started = @anime.started_airing_date
    if started.nil?
      started = "?"
    elsif started.day == 1 and started.month == 1
      started = started.year.to_s
    else
      started = started.strftime("%B %e, %Y")
    end

    finished = @anime.finished_airing_date
    if finished.nil?
      finished = "?"
    elsif finished.day == 1 and finished.month == 1
      finished = finished.year.to_s
    else
      finished = finished.strftime("%B %e, %Y")
    end

    if anime.status == "Finished Airing"
      display = "Aired"
    elsif anime.status == "Currently Airing"
      display = "Airing"
    else
      display = "Will air"
    end

    if anime.episode_count and anime.episode_count == 1
      display += " on #{started}"
    else
      display += " from #{started}"
      if finished != "?"
        display += " to #{finished}"
      end
    end

    display
  end
end

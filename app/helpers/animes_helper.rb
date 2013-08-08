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
      "Aired from #{started} to #{finished}"
    elsif anime.status == "Currently Airing"
      "Airing from #{started} to #{finished}"
    else
      "Will air from #{started} to #{finished}"
    end
  end
end

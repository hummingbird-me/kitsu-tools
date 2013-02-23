module EpisodesHelper
  # Get a list of four episodes from a list of a lot of episodes, trying its
  # best to ensure that the first has been watched by the user.
  #
  # Returns [[episode, watched?]].
  def select_four_episodes(anime, current_user)
    @episodes = anime.episodes.order(:number)
    @episodes_watched = Hash.new(false)
    @episodes_viewed = []
    if user_signed_in?
      @episodes_viewed = current_user.episodes_viewed(anime).includes(:episode)
    end
    @episodes_viewed.each do |episodev|
      @episodes_watched[ episodev.episode.id ] = true
    end
    # Figure out the range of 4 episodes to show.
    if @episodes_viewed.length == 0 or @episodes.length <= 4
      @episodes = @episodes[0..3]
    else
      latest_watched = @episodes_viewed.map {|x| x.episode.number }.max
      if latest_watched+2 > @episodes.length-1
        @episodes = @episodes[-4..-1]
      else
        @episodes = @episodes[(latest_watched-1)..(latest_watched+2)]
      end
    end    
    return @episodes.map {|e| [e, @episodes_watched[e.id]] }
  end
end

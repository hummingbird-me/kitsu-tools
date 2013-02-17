# Temporary shell script that will get all the data we want from MAL.
require 'open-uri'
require 'active_support/core_ext'
require 'nokogiri'
require 'pp'

username = ARGV[0]

# Get Watchlist.
watchlist = []
animelist = Hash.from_xml(open("http://myanimelist.net/malappinfo.php?status=all&type=anime&u=#{username}").read)
status_map = {
  "1"           => "Currently Watching",
  "watching"    => "Currently Watching",
  "2"           => "Completed",
  "completed"   => "Completed",
  "3"           => "On Hold",
  "onhold"      => "On Hold",
  "4"           => "Dropped",
  "dropped"     => "Dropped",
  "6"           => "Plan to Watch",
  "plantowatch" => "Plan to Watch"
}
animelist["myanimelist"]["anime"].each do |indv|
  parsd = {
    mal_id: indv["series_animedb_id"], 
    rating: indv["my_score"],
    episodes_watched: indv["my_watched_episodes"],
    status: status_map[indv["my_status"]],
    last_updated: Time.at(indv["my_last_updated"].to_i)
  }
  watchlist.push parsd
end

# Reviews.
reviews = []

def get_reviews(page)
  reviews = []
  page.css('div.borderDark').each do |rev|
    if rev.css('div.spaceit.borderLight small').text == "(Anime)"
      anime_id = rev.css('div.spaceit.borderLight a.hoverinfo_trigger')[0].attribute("href").value.scan(/^http:\/\/myanimelist\.net\/anime\/(\d+)\//).flatten[0]
      review = rev.css('div.spaceit.textReadability')[0].children[4..-3].text
      rating = rev.css('div.spaceit.borderLight div.spaceit div').select {|x| x.text.include? "Overall Rating" }[0].text.split[-1].to_i
      reviews.push({mal_id: anime_id, rating: rating, content: review})
    end
  end
  reviews
end

reviewpage = Nokogiri::HTML(open("http://myanimelist.net/profile/#{username}/reviews"))
reviews += get_reviews(reviewpage)
page = 0
while reviewpage.css('a').any? {|t| t.text == "More Reviews" }
  page += 1
  reviewpage = Nokogiri::HTML(open("http://myanimelist.net/profile/#{username}/reviews&p=#{page}"))
  reviews += get_reviews(reviewpage)
end

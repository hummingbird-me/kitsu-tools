class MoveQuoteSubmitStoriesToNewFormat < ActiveRecord::Migration
  def up
    Story.where(story_type: "submitted_quote").each {|x| s = Story.for_user_and_anime(x.user, x.quote.anime); Substory.create(user: x.user, substory_type: "submitted_quote", target: x.quote, story: s) }
    Story.where(story_type: "submitted_quote").each {|x| x.destroy }
    Story.where(story_type: "media_story").each {|story| begin; story.updated_at = story.substories.map {|x| x.created_at }.max; story.save; rescue; story.destroy; end }
  end

  def down
  end
end

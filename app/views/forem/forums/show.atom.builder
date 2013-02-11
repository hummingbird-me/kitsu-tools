atom_feed :language => 'en-US' do |feed|
  feed.title @forum.title
  feed.updated @topics.first.try(:updated_at)

  @topics.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url forem.forum_topic_url(@forum, item)
      entry.title item.subject
      entry.content forem_format(item.posts.first.text), :type => 'html'
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name item.user.to_s
      end
    end
  end
end

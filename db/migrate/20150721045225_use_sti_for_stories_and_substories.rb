class UseStiForStoriesAndSubstories < ActiveRecord::Migration
  def change
    rename_column :substories, :substory_type, :type

    add_column :stories, :type, :integer
    reversible do |dir|
      dir.up do
        say_with_time 'Migrate Story::LibraryEntry' do
          Story.unscoped.where(story_type: 'media_story').update_all(type: 0)
        end
        say_with_time 'Migrate Story::Comment' do
          Story.unscoped.where(story_type: 'comment').update_all(type: 1)
        end
        say_with_time 'Migrate Story::Followed' do
          Story.unscoped.where(story_type: 'followed').update_all(type: 2)
        end
      end
      dir.down do
        say_with_time 'Unmigrate Story::LibraryEntry' do
          Story.unscoped.where(type: 0).update_all(story_type: 'media_story')
        end
        say_with_time 'Unmigrate Story::Comment' do
          Story.unscoped.where(type: 1).update_all(story_type: 'comment')
        end
        say_with_time 'Unmigrate Story::Followed' do
          Story.unscoped.where(type: 2).update_all(story_type: 'followed')
        end
      end
    end
    change_column_null :stories, :type, false
    remove_column :stories, :story_type, :string
  end
end

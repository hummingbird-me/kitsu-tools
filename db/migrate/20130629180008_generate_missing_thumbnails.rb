class GenerateMissingThumbnails < ActiveRecord::Migration
  def up
    Character.find_each do |c|
      c.image.reprocess! :thumb_small
    end
    Person.find_each do |c|
      c.image.reprocess! :thumb_small
    end
  end

  def down
  end
end

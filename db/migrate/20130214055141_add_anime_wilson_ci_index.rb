class AddAnimeWilsonCiIndex < ActiveRecord::Migration
  def change
    add_index :anime, [:wilson_ci], {:order => {:wilson_ci => :desc}}
  end
end

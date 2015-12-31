require 'unlimited_paginator'

class LibraryEntryResource < BaseResource
  attributes :status, :episodes_watched, :rewatching, :rewatch_count,
             :notes, :private, :rating, :updated_at

  filters :user_id, :anime_id, :status

  has_one :user
  has_one :anime

  paginator :unlimited
end

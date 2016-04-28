require 'unlimited_paginator'

class LibraryEntryResource < BaseResource
  attributes :status, :progress, :reconsuming, :reconsume_count, :notes,
             :private, :rating, :updated_at

  filters :user_id, :media_id, :media_type, :status

  has_one :user
  has_one :media, polymorphic: true

  paginator :unlimited
end

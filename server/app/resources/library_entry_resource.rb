require 'unlimited_paginator'

class LibraryEntryResource < BaseResource
  attributes :status, :episodes_watched, :rewatching, :rewatch_count,
             :notes, :private, :rating, :updated_at

  filters :user_id, :anime_id, :status

  has_one :user
  has_one :anime

  paginator :unlimited

  after_replace_fields :correct_user?

  private

  def correct_user?
    is_user_or_admin = @model.user == current_user ||
                       current_user.has_role?(:admin, LibraryEntry)
    not_authorized! :create? unless is_new? && is_user_or_admin
  end
end

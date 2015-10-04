module Titleable
  extend ActiveSupport::Concern

  included do
    validates :canonical_title, presence: true
    validate :has_romaji_title
  end

  def canonical_title
    titles[self[:canonical_title]]
  end

  private

  def has_romaji_title?
    titles.key?('ja_en')
  end

  def has_romaji_title
    errors.add(:titles, 'must have ja_en title') unless has_romaji_title?
  end
end

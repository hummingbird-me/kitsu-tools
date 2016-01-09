module Titleable
  extend ActiveSupport::Concern

  included do
    validates :canonical_title, presence: true
    validate :has_english_title
  end

  def canonical_title
    titles[self[:canonical_title]]
  end

  private

  def has_english_title?
    titles.keys.any? { |k| k.end_with?('_en') || k.start_with?('en_') }
  end

  def has_english_title
    unless has_english_title?
      errors.add(:titles, 'must have at least one english title')
    end
  end
end

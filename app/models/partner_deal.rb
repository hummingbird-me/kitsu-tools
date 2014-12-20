# == Schema Information
#
# Table name: partner_deals
#
#  id                        :integer          not null, primary key
#  deal_title                :string(255)      not null
#  partner_name              :string(255)      not null
#  valid_countries           :string(255)      not null, is an Array
#  partner_logo_file_name    :string(255)
#  partner_logo_content_type :string(255)
#  partner_logo_file_size    :integer
#  partner_logo_updated_at   :datetime
#  deal_url                  :text             not null
#  deal_description          :text             not null
#  redemption_info           :text             not null
#  recurring                 :boolean          default(FALSE), not null
#  active                    :boolean          default(TRUE), not null
#

class PartnerDeal < ActiveRecord::Base
  scope :available_in, -> country { where('? = ANY(valid_countries)', country.upcase) }

  # Field Macros
  has_many :codes, class_name: 'PartnerCode'
  has_attached_file :partner_logo

  # Validations
  validates_attachment :partner_logo, presence: true, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }
  validates :deal_title, presence: true
  validates :partner_name, presence: true
  validates :deal_url, presence: true
  validates :deal_description, presence: true
  validates :redemption_info, presence: true

  # Force all valid countries to uppercase for storage
  before_save do
    valid_countries.map!(&:upcase)
  end

  rails_admin do
    edit do
      field :partner_name
      field :partner_logo
      field :deal_title
      field :deal_url, :string
      field :deal_description
      field :redemption_info
      field :recurring
      field :active
      field :valid_countries, :pg_string_array
    end
  end
end

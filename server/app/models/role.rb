# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string           indexed, indexed => [resource_type, resource_id]
#  resource_type :string           indexed => [name, resource_id]
#  created_at    :datetime
#  updated_at    :datetime
#  resource_id   :integer          indexed => [name, resource_type]
#
# Indexes
#
#  index_roles_on_name                                    (name)
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#
# rubocop:enable Metrics/LineLength

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  validates :resource_type,
    inclusion: { in: Rolify.resource_types },
    allow_nil: true

  scopify
end

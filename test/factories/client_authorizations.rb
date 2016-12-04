# == Schema Information
#
# Table name: client_authorizations
#
#  id         :integer          not null, primary key
#  scopes     :string(255)      default([]), not null, is an Array
#  app_id     :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :client_authorization do
    app factory: :app_with_creator
    user
    scopes { %w[all] }
  end
end

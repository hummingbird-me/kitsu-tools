class ProMembershipPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :amount, :duration, :recurring
end

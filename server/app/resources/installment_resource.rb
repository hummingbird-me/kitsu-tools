class InstallmentResource < BaseResource
  attributes :tag, :position

  has_one :franchise
  has_one :media, polymorphic: true
end

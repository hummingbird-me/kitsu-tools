class FranchiseResource < BaseResource
  attributes :titles, :canonical_title

  has_many :installments
end

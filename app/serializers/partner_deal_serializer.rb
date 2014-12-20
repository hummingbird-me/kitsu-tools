class PartnerDealSerializer < ActiveModel::Serializer
  attributes :id, :partner_name, :partner_logo, :deal_title, :deal_url,
    :deal_description, :redemption_info, :recurring, :active, :codes_remaining

  def codes_remaining
    object.codes.count
  end

  def include_codes_remaining?
    scope.admin? if scope
  end
end

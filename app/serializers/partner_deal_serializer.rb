class PartnerDealSerializer < ActiveModel::Serializer
  attributes :id, :partner_name, :partner_logo, :deal_title, :deal_url,
    :deal_description, :redemption_info, :recurring, :has_codes, :code

  def has_codes
    object.codes.unclaimed.count > 0
  end

  def code
    scope && object.codes.where(user: scope).last.try(:code)
  end
end

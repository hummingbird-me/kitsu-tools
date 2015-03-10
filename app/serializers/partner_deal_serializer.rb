class PartnerDealSerializer < ActiveModel::Serializer
  attributes :id, :partner_name, :partner_logo, :deal_title, :deal_url,
    :deal_description, :redemption_info, :recurring, :has_codes, :code,
    :claimed_at

  def has_codes
    object.codes.unclaimed.count > 0
  end

  def code
    code_object && code_object.code
  end

  def claimed_at
    code_object && code_object.claimed_at
  end

  private

  def code_object
    scope && object.codes.where(user: scope).last
  end
end

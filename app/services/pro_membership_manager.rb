class ProMembershipManager
  def initialize(user)
    @user = user
  end

  # Subscribe the user to the given plan using the given token. If they are a
  # new subscriber, charge them immediately. If they are already pro and just
  # switching plans then update their token, move them to the new plan and only
  # charge them when their current subscription runs out, i.e. don't charge them
  # right now.
  def subscribe!(plan, token)
    # Charge the credit card.
    charge_user! token, (plan.amount * 100).to_i

    # Update the user's subscription.
    if @user.pro_expires_at.nil? || @user.pro_expires_at < Time.now
      @user.pro_expires_at = Time.now
    end
    @user.pro_expires_at += 1.month
    @user.pro_membership_plan_id = plan.id
    @user.stripe_token = token
    @user.save!
  end

  # Unset the user's plan, but allow their current membership to continue. Only
  # useful when the user is on a recurring plan.
  def cancel!
    @user.pro_membership_plan_id = nil
    @user.save!
  end

  # Renew the user's pro membership. Make sure the plan they are on is recurring
  # first. If we don't succeed in charging the user then send a dunning email
  # and let their membership expire.
  def renew!
    # TODO we don't actually need this until one month after we launch PRO.
  end

  private

  # Charge the user's card the given amount in cents.
  def charge_user!(token, amount)
    customer = Stripe::Customer.create(
      email: @user.email,
      card: token
    )
    Stripe::Charge.create(
      customer: customer.id,
      amount: amount,
      description: "Hummingbird PRO",
      currency: 'usd'
    )
  end
end

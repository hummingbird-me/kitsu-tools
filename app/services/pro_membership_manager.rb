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
    @user.pro_membership_plan_id = plan.id
    @user.stripe_token = token

    unless @user.pro? && plan.recurring?
      # Charge the credit card.
      charge_user! token, (plan.amount * 100).to_i

      # Update the user's subscription.
      if @user.pro_expires_at.nil? || @user.pro_expires_at < Time.now
        @user.pro_expires_at = Time.now
      end
      @user.pro_expires_at += plan.duration.months
    end

    @user.save!
  end

  def gift!(token, plan, gift_to, gift_message)
    if plan.recurring?
      raise "Recurring subscriptions cannot be gifted"
    end

    charge_user! token, (plan.amount * 100).to_i

    if gift_to.pro_expires_at.nil? || gift_to.pro_expires_at < Time.now
      gift_to.pro_expires_at = Time.now
    end
    gift_to.pro_expires_at += plan.duration.months

    gift_to.save!
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
    Stripe::Charge.create(
      customer: stripe_customer(token).id,
      amount: amount,
      description: "Hummingbird PRO",
      currency: 'usd'
    )
  end

  def stripe_customer(token)
    customer = nil
    unless @user.stripe_customer_id.blank?
      begin
        customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      rescue
      end
      customer = nil if customer.deleted?
    end
    if customer.nil?
      customer = Stripe::Customer.create(email: @user.email, card: token)
      @user.update_attributes! stripe_customer_id: customer.id
    end
    customer
  end
end

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
    @user.update_attributes! pro_membership_plan_id: plan.id,
                             stripe_token: token

    unless @user.pro? && plan.recurring?
      charge_user! token, (plan.amount * 100).to_i
      give_pro! @user, plan.duration.months
    end

    ProMailer.delay.welcome_email(@user)
  end

  # Charge the user, then add the resulting PRO duration to a different user to
  # whom the PRO is being gifted.
  def gift!(plan, token, gift_to, gift_message)
    if plan.recurring?
      raise "Recurring subscriptions cannot be gifted"
    end

    charge_user! token, (plan.amount * 100).to_i
    give_pro! gift_to, plan.duration.months

    ProMailer.delay.gift_email(gift_to, @user, gift_message)
  end

  # Unset the user's plan, but allow their current membership to continue. Only
  # useful when the user is on a recurring plan.
  def cancel!
    @user.pro_membership_plan_id = nil
    @user.save!
    ProMailer.delay.cancel_email(@user)
  end

  # Renew the user's pro membership. Make sure the plan they are on is recurring
  # first. If we don't succeed in charging the user then send a dunning email
  # and let their membership expire.
  def renew!(attempt_number: 0)
    token = @user.stripe_token
    plan = @user.pro_membership_plan

    unless plan.recurring?
      raise "Cannot renew non-recurring plan"
    end

    charge_user! token, (plan.amount * 100).to_i
    give_pro! @user, plan.duration.months

    # if this is a retry, tell the user it worked
    if attempt_number > 0
      ProMailer.delay.renew_succeeded_email(@user, attempt_number)
    end
  rescue Stripe::CardError
    ProMailer.delay.renew_failed_email(@user, attempt_number)
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
    end
    if customer.nil?
      customer = Stripe::Customer.create(email: @user.email, card: token)
      @user.update_attributes! stripe_customer_id: customer.id
    end
    customer
  end

  def give_pro!(user, duration)
    if user.pro_expires_at.nil? || user.pro_expires_at < Time.now
      user.pro_expires_at = Time.now
    end
    user.pro_expires_at += duration
    user.save!
  end
end

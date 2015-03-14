class ProMembershipManager
  def initialize(user)
    @user = user
  end

  # Subscribe the user to the given plan using the given token. If they are a
  # new subscriber, charge them immediately. If they are already pro and just
  # switching plans then update their token, move them to the new plan and only
  # charge them when their current subscription runs out, i.e. don't charge them
  # right now.
  def subscribe!(plan)
    @user.update_attributes! pro_membership_plan_id: plan.id

    # Unless user is already pro and switching to a recurring plan
    unless @user.pro? && plan.recurring?
      billing_method.charge! @user, plan.amount
      give_pro! @user, plan.duration.months
    end

    ProMailer.delay.welcome_email(@user)
  end

  # Charge the user, then add the resulting PRO duration to a different user to
  # whom the PRO is being gifted.
  def gift!(plan, gift_to, gift_message)
    raise "Recurring subscriptions cannot be gifted" if plan.recurring?

    billing_method.charge! @user, plan.amount
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
    plan = @user.pro_membership_plan

    raise "Cannot renew non-recurring plan" unless plan.recurring?

    billing_method.charge! @user, plan.amount
    give_pro! @user, plan.duration.months

    # if this is a retry, tell the user it worked
    if attempt_number > 0
      ProMailer.delay.renew_succeeded_email(@user, attempt_number)
    end
  rescue Stripe::CardError
    ProMailer.delay.renew_failed_email(@user, attempt_number)
  end

  private
  def billing_method
    @payment_method ||= PaymentMethod.lookup(@user.billing_method)
  end

  def give_pro!(user, duration)
    if user.pro_expires_at.nil? || user.pro_expires_at < Time.now
      user.pro_expires_at = Time.now
    end
    user.pro_expires_at += duration
    user.save!
  end
end

class ProMembershipsController < ApplicationController

  before_filter :authenticate_user!

  def create
    params.permit(:token, :plan_id, :gift, :gift_to, :gift_message)

    if params[:token].blank?
      return render(text: "Didn't get credit card details from Stripe", status: 400)
    end

    if params[:plan_id].blank?
      return render(text: "No membership plan was selected", status: 400)
    end

    token, plan_id = params[:token], params[:plan_id].to_i

    begin
      plan = ProMembershipPlan.find(plan_id)
    rescue ActiveRecord::RecordNotFound
      return render(text: "No such membership plan exists", status: 400)
    end

    begin
      update_billing current_user, token

      if params[:gift]
        gift_to = nil
        begin
          gift_to = User.find(params[:gift_to])
        rescue
          return render(text: "Couldn't find user: #{params[:gift_to]}", status: 400)
        end
        manager.gift! plan, gift_to, params[:gift_message]
        mixpanel.track "PRO gifted", {
          gifted_to: gift_to.name,
          gifted_by: current_user.name,
          plan: plan.name
        }
      else
        manager.subscribe! plan
        mixpanel.track "PRO subscription", {
          username: current_user.name,
          plan: plan.name
        }
      end
    rescue Exception => e
      return render(text: "Unknown error: #{e.message}", status: 400)
    end

    render text: "subscription successful"
  end

  def destroy
    manager.cancel!
    render text: "unsubscribed"
  end

  private
  def update_billing(user, token)
    customer = payment_method.exchange_token(token)
    user.update_attributes! billing_method: :stripe,
                            billing_id: customer.id
  end

  def manager
    @manager ||= ProMembershipManager.new(current_user)
  end

  def payment_method
    @method ||= PaymentMethod.lookup('stripe')
  end
end

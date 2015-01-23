class ProRenewRetryWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform(last, current)
    last, current = Time.at(last), Time.at(current)
    recurring_plans = ProMembershipPlan.recurring_plans.map(&:id)
    tries = Array.new(3)
    tries[0] = User.where(pro_membership_plan_id: recurring_plans,
                          pro_expires_at: (current - 2.days)..(current - 1.day))
    tries[1] = User.where(pro_membership_plan_id: recurring_plans,
                          pro_expires_at: (current - 4.days)..(current - 3.days))
    tries[2] = User.where(pro_membership_plan_id: recurring_plans,
                          pro_expires_at: (current - 6.days)..(current - 5.days))

    tries.each.with_index do |users, index|
      users.all.each do |user|
        manager = ProMembershipManager.new(user)
        manager.renew! attempt: index+1
      end
    end
  end
end

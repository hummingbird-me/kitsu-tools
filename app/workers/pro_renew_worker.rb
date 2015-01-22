class ProRenewWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform(last, current)
    recurring_plans = ProMembershipPlan.recurring_plans.map(&:id)
    # Anything which wasn't caught in the last run, up until 1 hour from now
    users = User.where(pro_membership_plan_id: recurring_plans,
                       pro_expires_at: (last + 1.hour)..(current + 1.hour))

    users.all.each do |user|
      manager = ProMembershipManager.new(user)
      manager.renew!
    end
  end
end

class ProRenewWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform(last, current)
    # Anything which wasn't caught in the last run, up until 1 hour from now
    users = User.where(pro_membership_id: ProMembershipPlan.recurring_plans.map(&:id),
                       pro_expires_at: (last + 1.hour)..(1.hour.from_now))

    users.all.each do |user|
      manager = ProMembershipManager.new(user)
      manager.renew!
    end
  end
end

class ProExpiryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    # Any users with nonrecurring plans expiring in the next 24 hours
    users = User.where(pro_membership_plan_id: ProMembershipPlan.nonrecurring_plans.map(&:id),
                       pro_expires_at: (Time.now)..(1.day.from_now))

    users.all.each do |user|
      ProMailer.expiring_email(user)
    end
  end
end


class ProExpiryEmailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform(last, current)
    last, current = Time.at(last), Time.at(current)
    # Any users with nonrecurring plans expiring in the next 24 hours
    users = User.where(pro_membership_plan_id: ProMembershipPlan.nonrecurring_plans.map(&:id),
                       pro_expires_at: (current)..(current + 1.day))

    users.all.each do |user|
      ProMailer.expiring_email(user)
    end
  end
end


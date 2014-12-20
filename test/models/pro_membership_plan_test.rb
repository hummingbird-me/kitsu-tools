require 'test_helper'

class ProMembershipPlanTest < ActiveSupport::TestCase
  test "can find by id" do
    assert_not_nil ProMembershipPlan.find(1)
  end

  test "raises error when id not found" do
    assert_raise ActiveRecord::RecordNotFound do
      ProMembershipPlan.find(-1)
    end
  end

  test "can find all plans" do
    assert_not_empty ProMembershipPlan.all
  end

  test "all plans have the amount in their name" do
    ProMembershipPlan.all.each do |plan|
      assert plan.name.include?(plan.amount.to_s)
    end
  end
end

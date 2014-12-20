require 'bigdecimal'

class ProMembershipPlan

  attr_reader :id,
              :name, # plan name
              :amount, # how much the plan costs, in USD
              :duration, # how long it is valid for, in months
              :recurring # is it recurring?

  PLANS = [
    {id: 1, name: "monthly - $4.99", amount: BigDecimal.new("4.99"), duration: 1, recurring: true},
    {id: 2, name: "yearly - $39.99 (~$3.33/month)", amount: BigDecimal.new("39.99"), duration: 12, recurring: true},
    {id: 3, name: "1 month: $4.99", amount: BigDecimal.new("4.99"), duration: 1, recurring: false},
    {id: 4, name: "3 months: $11.97", amount: BigDecimal.new("11.97"), duration: 3, recurring: false},
    {id: 5, name: "12 months (special price!): $39.99", amount: BigDecimal.new("39.99"), duration: 12, recurring: false},
    {id: 6, name: "24 months (special price!): $59.98", amount: BigDecimal.new("59.98"), duration: 24, recurring: false},
    {id: 7, name: "36 months (special price!): $89.97", amount: BigDecimal.new("89.97"), duration: 36, recurring: false}
  ]

  def initialize(hash)
    @id = hash[:id]
    @name = hash[:name]
    @amount = hash[:amount]
    @duration = hash[:duration]
    @recurring = hash[:recurring]
  end

  def self.find(id)
    plan = PLANS.find {|x| x[:id] == id }
    raise ActiveRecord::RecordNotFound.new if plan.nil?
    self.new(plan)
  end

  def self.all
    PLANS.map {|plan| self.new(plan) }
  end

end

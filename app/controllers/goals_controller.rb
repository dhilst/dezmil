class GoalsController < ApplicationController
  def index
    raise ActionController::RoutingError.new('Not Found') unless current_user.email == 'danielhilst@gmail.com'
    @goal = 10_000
    @transactions = current_user.transactions
      .joins(:category)
      .where('categories.name = ? or categories.name = ?', 'invest', 'divestiment')
    total_invested = 0
    @last_months_sum = @transactions.sum(:amount) * -1
    @total = total_invested + @last_months_sum
    @progress = @total * 100.0 / @goal
    @progress = 0 if @progress < 0
    @months = @transactions.count("extract(month from transactions.date)")
    @avg_by_month = @last_months_sum / @months
    missing_amount = @goal - @total
    missing = missing_amount / @avg_by_month
    @estimated = Time.zone.today.beginning_of_month + missing.to_i.months
  end
end

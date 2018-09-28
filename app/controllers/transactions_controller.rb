class TransactionsController < ApplicationController
	before_action :authenticate_user!

	def index
		year = (params[:year] || Date.today.year).to_i
		month = (params[:month] || Date.today.month).to_i
		@d = Date.new(year, month)
		@transactions = current_user.transactions.where(date: @d.beginning_of_month..@d.end_of_month)
	end
end

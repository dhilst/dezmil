class TransactionsController < ApplicationController
	before_action :authenticate_user!, :set_date

	def index
		@transactions = current_user.transactions.month(@d)
	end

	def search

		if params[:pattern].empty?
			redirect_to action: :index
			return
		end

		@transactions = current_user.transactions.month(@d)
			.where('length(memo) - levenshtein(lower(memo),lower(:pattern)) > length(:pattern) * 0.70', pattern: params[:pattern])
		render :index
	end

	private
		def set_date
			year = (params[:year] || Date.today.year).to_i
			month = (params[:month] || Date.today.month).to_i
			@d = Date.new(year, month)
		end
end

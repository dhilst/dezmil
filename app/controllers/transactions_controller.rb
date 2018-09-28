class TransactionsController < ApplicationController
	before_action :authenticate_user!

	def index
		@transactions = Transaction.all
	end

	def show
		@transaction = Transaction.find(params[:id])
	end
end

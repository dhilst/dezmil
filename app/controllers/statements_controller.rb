class StatementsController < ApplicationController

	def index
		@statement = Statement.all
	end

	def new
		@statement = Statement.new
	end

	def create
		fil = params[:statement][:file]
		OFX fil.tempfile do |p|
			@statement = current_user.statements.create(
				number: p.account.id,
				balance: p.account.balance.amount)
			p.account.transactions.each do |t|
				@statement.transactions << Transaction.new(
					memo: t.memo,
					amount: t.amount,
					date: t.posted_at,
				)
			end
		end
		redirect_to @statement
	end

	def show
		@statement = Statement.find(params[:id])
	end
end

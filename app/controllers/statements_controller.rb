class StatementsController < ApplicationController

	def index
		@statement = Statement.all
	end

	def new
		@statement = Statement.new
	end

	def create
		fil = params[:statement][:file]
    uncat = Category.find_by(name: 'uncategorized')
		OFX fil.tempfile do |p|
			@statement = current_user.statements.create(
				number: p.account.id,
				balance: p.account.balance.amount)
			p.account.transactions.each do |t|
        @statement.transactions.create!(
					memo: t.memo,
					amount: t.amount,
					date: t.posted_at,
          category:  uncat,
				)
			end
		end
		redirect_to '/'
	end

	def show
		@statement = Statement.find(params[:id])
	end
end

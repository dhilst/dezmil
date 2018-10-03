class StatementsController < ApplicationController

	def index
		@statement = Statement.all
	end

	def new
		@statement = Statement.new
	end

	def create
		fil = params[:statement][:file]
    uncat = Category.find(1)
		OFX fil.tempfile do |p|
			@statement = current_user.statements.create(
				number: p.account.id,
				balance: p.account.balance.amount)
			p.account.transactions.each do |t|
        query = <<-EOF
        select categories.id
        from  transactions
        join  categories on categories.id = transactions.category_id
        where categories.name <> 'uncategoried' and
              (length(transactions.memo) - levenshtein(lower(transactions.memo),lower('#{t.memo}')))::float / length(transactions.memo) > 0.9
        group by categories.id
        having count(categories.id) >= 3
        order by count(categories.id)
        EOF
        categories = ActiveRecord::Base.connection.execute(query)
        cat = Category.find(categories.first['id']) if categories.count > 0
        @statement.transactions.create(
					memo: t.memo,
					amount: t.amount,
					date: t.posted_at,
          category: cat || uncat,
				)
			end
		end
    if @statement.transactions.count == 0
      @statement.destroy
      flash[:info] = 'Nada de novo, tente exportar outro extrato!'
      redirect_to '/'
    else
      flash[:success] = "Yay!, #{@statement.transactions.count} novas linhas!" 
      redirect_to controller: :transactions, action: :statement, id: @statement.id
    end
	end

	def show
		@statement = Statement.find(params[:id])
	end
end

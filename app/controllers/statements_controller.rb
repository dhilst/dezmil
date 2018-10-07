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
        bank: p.account.bank_id,
        currency: p.account.currency,
				number: p.account.id,
				balance: p.account.balance.amount,
        date: p.account.balance.posted_at,
      )

      unless @statement.persisted?
        @statement = current_user.statements.find_by(
          bank: p.account.bank_id,
          currency: p.account.currency,
          number: p.account.id,
          balance: p.account.balance.amount,
          date: p.account.balance.posted_at,
        )
        flash[:info] = 'Esse extrato já tinha sido importado antes ...'
        redirect_to controller: :transactions, action: :statement, id: @statement.id
        return
      end

      accbalance = p.account.balance.amount
      p.account.transactions.select{|t| t.posted_at <= p.account.balance.posted_at }.reverse_each do |t|
        query = <<-EOF
        select categories.id
        from  transactions
        join  categories on categories.id = transactions.category_id
        where categories.name <> 'uncategorized' and
              (length(transactions.memo) - levenshtein(lower(transactions.memo),lower('#{t.memo}')))::float / length(transactions.memo) > 0.9
        group by categories.id
        having count(categories.id) >= 1
        order by count(categories.id)
        EOF
        categories = ActiveRecord::Base.connection.execute(query)
        cat = Category.find(categories.first['id']) if categories.count > 0
        @statement.transactions.create(
					memo: t.memo,
					amount: t.amount,
					date: t.posted_at,
          category: cat || uncat,
          balance: accbalance,
        )
        accbalance += t.amount
			end

      accbalance = p.account.balance.amount
      p.account.transactions.select{|t| t.posted_at > p.account.balance.posted_at }.reverse_each do |t|
        query = <<-EOF
        select categories.id
        from  transactions
        join  categories on categories.id = transactions.category_id
        where categories.name <> 'uncategorized' and
              (length(transactions.memo) - levenshtein(lower(transactions.memo),lower('#{t.memo}')))::float / length(transactions.memo) > 0.9
        group by categories.id
        having count(categories.id) >= 1
        order by count(categories.id)
        EOF
        categories = ActiveRecord::Base.connection.execute(query)
        cat = Category.find(categories.first['id']) if categories.count > 0
        accbalance += t.amount
        binding.pry
        @statement.transactions.create(
					memo: t.memo,
					amount: t.amount,
					date: t.posted_at,
          category: cat || uncat,
          balance: accbalance,
        )
			end
		end
    if @statement.transactions.count == 0
      @statement.destroy
      flash[:info] = 'Nada de novo, tente exportar outro extrato!'
      redirect_to '/'
    else
      flash[:success] = "Yay!, #{@statement.transactions.count} novas linhas!" 
      count = @statement.transactions.joins(:category).where("categories.name <> 'uncategorized'").count()
      flash[:info] = "#{count} lines already categorized!!!" if count > 0
      redirect_to controller: :transactions, action: :statement, id: @statement.id
    end
	end

	def show
		@statement = Statement.find(params[:id])
	end
end

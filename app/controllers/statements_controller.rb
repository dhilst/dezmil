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
    query = <<-EOF
    select categories.id, count(categories.id)
    from  transactions
    join  categories on categories.id = transactions.category_id
    where transactions.date between '2018-09-01' and '2018-09-30' and
          categories.name <> 'uncategoried' and
          (length(transactions.memo) - levenshtein(lower(transactions.memo),lower('DEBITO VISA ELECTRON BRASIL 21/09 PAO A MAO COMFO')))::float / length(transactions.memo) > 0.9
    group by categories.id
    having count(categories.id) >= 3
    order by count(categories.id)
    EOF
			@statement = current_user.statements.create(
				number: p.account.id,
				balance: p.account.balance.amount)
			p.account.transactions.each do |t|
        @statement.transactions.create(
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

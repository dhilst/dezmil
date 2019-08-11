# Monkey patch OFX
class OFX::Transaction
  attr_accessor :balance
end


class StatementsController < ApplicationController

	def index
		@statement = Statement.all
	end

	def new
		@statement = Statement.new
	end

	def create
		fil = params[:statement][:file]
    p = parse(fil.tempfile)

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

    p.account.transactions.each do |t|
      # This will run for every tranaction on the statement. It may be very
      # expensive. Using a full text index would be better. Basically we're
      # searching for categories used in transactions where the
      # transaction.memo field has more than 90% of correspondence.
      #
      # If found, such transaction is categorized automatically. This matches
      # with global categories and user ones.
      query = <<-EOF
      select categories.id as category_id
      from  transactions
      join  categories on categories.id = transactions.category_id
      where (categories.name <> 'uncategorized' or categories.name is NULL) and
            (categories.user_id = #{current_user.id} or categories.user_id is null) and
            (length(transactions.memo) - levenshtein(lower(transactions.memo),lower('#{t.memo}')))::float / length(transactions.memo) > 0.9
      group by categories.id
      having count(categories.id) >= 1
      order by count(categories.id)
      limit 1
      EOF
      categories = ActiveRecord::Base.connection.execute(query)
      @statement.transactions.create(
        memo: t.memo,
        amount: t.amount,
        date: t.posted_at,
        category_id: categories.first&.category_id,
        balance: t.balance
      )
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

  private

  def parse(fil)
    OFX File.open(fil) do |parser|
      acc = parser.account.balance.amount
      parser.account.transactions.reverse_each do |t|
        t.balance = acc
        acc -= t.amount
      end
      parser
    end
  end
end

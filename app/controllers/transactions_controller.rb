class TransactionsController < ApplicationController
	before_action :authenticate_user!
  before_action :load_d
  before_action :load_transactions
  before_action :load_statement

  def index
    redirect_to "/transactions/#{@d.year}/#{@d.month}"
  end

  def statement
    @transactions = Transaction.joins(:statement).where(statement_id: params[:id]).order(:date).order('memo desc')
    render :index
  end

  def category_amount
    amount = current_user.transactions.month(1.month.ago).joins(:category).where(category: params[:id]).sum(:amount)
    render json: amount
  end

  def charts
    respond_to do |format|
      format.json { render json: transactions
        .joins(:category)
        .select('categories.color as color',
                'amount',
                'date',
                'memo') }
      format.html
    end 
  end

  def month
    if params[:pattern].present?
      return search
    end

    # Redirect user to import if no statements is found
    if current_user.statements.count == 0
      redirect_to(controller: :statements, action: :new)
      return
    end

    @goaltotal = current_user.transactions
      .joins(:category)
      .where(categories: { name: %w[invest divestiment] })
      .sum(:amount)
    @goalprogress = @goaltotal.abs * 100 / 10000
    @transactions = current_user.transactions.month(@d).order(:date, :id, :memo)
    if params[:category]
      session.delete :groupby
      @transactions = @transactions.joins(:category).where('categories.id = ?', params[:category])
    end
    total_count = @transactions.count
    if total_count > 0
      @progress = @transactions.joins(:category).where('categories.id != ?', 1).count * 100 / total_count
    else
      @progress = 0
    end
    groupby_filter
    respond_to do |format|
      format.html { render :index }
    end
  end

  def groupby
    session[:groupby] = params[:group]
    logger.info "Session changed :groupby => #{session[:groupby]}"
    redirect_to action: :month, year: @d.year, month: @d.month
  end

  def set_category
    current_user.transactions.find(params[:id]).update_attributes(category: Category.find_by(id: params[:category]))
  end

	private

	def search
    session.delete :groupby

		if params[:pattern].empty?
			redirect_to action: :index
			return
		end

		@transactions = current_user.transactions.month(@d)
      .agrep(params[:pattern], 0.9)
    groupby_filter
		render :index
	end

  def load_d
    d
  end

  def d
    year = (params[:year] || Date.today.year).to_i
    month = (params[:month] || Date.today.month).to_i
    @d ||= Date.new(year, month)
  end

  def groupby_filter
    group = session[:groupby]
    return if group == 'ungrouped'
    logger.debug "filtering transactoins by #{group}"
    @total_in  = current_user.transactions.month(@d).where('transactions.amount > 0').sum('transactions.amount')
    @total_out = current_user.transactions.month(@d).where('transactions.amount < 0').sum('transactions.amount')
    case group
    when 'day'
      @transactions = current_user.transactions
        .select('transactions.date,
                 sum(case when transactions.amount > 0 then transactions.amount else NULL end) as _credit,
                 sum(case when transactions.amount < 0 then transactions.amount else NULL end) as _debit')
        .month(@d)
        .group('transactions.date')
      @grouped = true
    when 'week'
      @transactions = current_user.transactions
        .select('extract(\'week\' from transactions.date)::int as date,
                 sum(case when transactions.amount > 0 then transactions.amount else NULL end) as _credit,
                 sum(case when transactions.amount < 0 then transactions.amount else NULL end) as _debit')
        .month(@d)
        .group('extract(\'week\' from transactions.date)')
      @grouped = true
    when 'category'
      @lines = current_user.transactions.joins(:category).group('categories.id').count.length
      @transactions = current_user
        .transactions
        .select('(case when categories.display_name = \'selecione ..\' then \'Sem categoria\' else categories.display_name end) as display_name,
                 categories.id as category_id,
                 sum(case when transactions.amount > 0 then transactions.amount else NULL end) as _credit,
                 sum(case when transactions.amount < 0 then transactions.amount else NULL end) as _debit')
        .joins(:category)
        .where(categories: { user_id: [nil, current_user.id] })
        .month(@d)
        .group('categories.id', 'categories.display_name')
        .order('_debit')
      @categorygroup = true
      @prev_month_amount = if @d.month == Time.zone.now.month
        current_user.transactions
          .where('transactions.date between ? and ?', 1.month.ago.beginning_of_month, 1.month.ago)
          .joins(:category)
          .group('categories.id')
          .sum(:amount)
      else
        current_user.transactions
          .where('transactions.date between ? and ?', @d.prev_month.beginning_of_month, @d.prev_month.end_of_month)
          .joins(:category)
          .group('categories.id')
          .sum(:amount)
      end
      @grouped = true
    else
      @transactions = @transactions.order('date, memo')
      @grouped = false
    end
  end

  def load_statement
    @statement = current_user.statements.where('statements.date between ? and ?', @d.beginning_of_month, @d.end_of_month).order('statements.date').last
  end

  def transactions
    @transactions ||= current_user.transactions.month(d)
  end

  def load_transactions
    transactions
  end
end

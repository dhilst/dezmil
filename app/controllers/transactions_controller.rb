class TransactionsController < ApplicationController
	before_action :authenticate_user!, :set_date
  before_action :load_statement

  def index
    redirect_to "/transactions/#{@d.year}/#{@d.month}"
  end

  def statement
    @transactions = Transaction.joins(:statement).where(statement_id: params[:id]).order(:date).order('memo desc')
    render :index
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
      .sum(:amount) * -1
    @goalprogress = @goaltotal * 100 / 10000
    @transactions = current_user.transactions.month(@d).order(:date, :id, :memo)
    if params[:category]
      session.delete :groupby
      @transactions = @transactions.joins(:category).where('categories.name = ?', params[:category])
    end
    total_count = @transactions.count
    if total_count > 0
      @progress = @transactions.joins(:category).where('categories.name != ?', "uncategorized").count * 100 / total_count
    else
      @progress = 0
    end
    groupby_filter
    render :index
  end


  def groupby
    session[:groupby] = params[:group]
    logger.info "Session changed :groupby => #{session[:groupby]}"
    redirect_to action: :month, year: @d.year, month: @d.month
  end

  def set_category
   current_user.transactions.find(params[:id]).update_attributes(category: Category.find_by(name: params[:category]))
  end

  def routes
    dates = current_user.transactions.select('to_char(transactions.date, \'YYYY/MM\') as d').group(:d).map(&:d)

    routes = []
    dates.map do |month_route|
      routes << "/transactions/#{month_route}"
      routes << "/transactions/#{month_route}/groupby/day"
      routes << "/transactions/#{month_route}/groupby/week"
      routes << "/transactions/#{month_route}/groupby/category"
    end

    render json: routes
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

  def set_date
    year = (params[:year] || Date.today.year).to_i
    month = (params[:month] || Date.today.month).to_i
    @d = Date.new(year, month)
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
      @transactions = current_user.transactions
        .select('(case when categories.display_name = \'selecione ..\' then \'Sem categoria\' else categories.display_name end) as display_name, categories.id,
                 categories.name as category_name,
                 sum(case when transactions.amount > 0 then transactions.amount else NULL end) as _credit,
                 sum(case when transactions.amount < 0 then transactions.amount else NULL end) as _debit')
        .joins(:category)
        .month(@d)
        .group('categories.id')
        .order('_debit')
      @categorygroup = true
      @grouped = true
    else
      @transactions = @transactions.order('date, memo')
      @grouped = false
    end
  end

  def load_statement
    @statement = current_user.statements.where('statements.date between ? and ?', @d.beginning_of_month, @d.end_of_month).order('statements.date').last
  end
end

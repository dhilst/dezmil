class TransactionsController < ApplicationController
	before_action :authenticate_user!, :set_date

  def index
    redirect_to "/transactions/#{@d.year}/#{@d.month}"
  end

  def month
    @transactions = current_user.transactions.month(@d)
    total_count = @transactions.count
    if total_count > 0
      @progress = @transactions.joins(:category).where('categories.name != ?', "uncategoried").count * 100 / total_count
    end
    groupby_filter
    render :index
  end

	def search

    session.delete :groupby

		if params[:pattern].empty?
			redirect_to action: :index
			return
		end

		@transactions = current_user.transactions.month(@d)
			.where('length(memo) - levenshtein(lower(memo),lower(:pattern)) > length(:pattern) * 0.90', pattern: params[:pattern])
    groupby_filter
		render :index
	end

  def groupby
    session[:groupby] = params[:group]
    logger.info "Session changed :groupby => #{session[:groupby]}"
    redirect_to action: :index
  end

  def set_category
   current_user.transactions.find(params[:id]).update_attributes(category: Category.find_by(name: params[:category]))
  end

	private
		def set_date
			year = (params[:year] || Date.today.year).to_i
			month = (params[:month] || Date.today.month).to_i
			@d = Date.new(year, month)
		end

    def groupby_filter
      group = session[:groupby]
      return if group == 'ungrouped'
      logger.debug "filtering transactoins by #{group}"
      case group
      when 'day'
        @transactions = @transactions.order(:date).group(:date).sum(:amount).map do |result|
          Transaction.new(date: result[0], memo: nil, amount: result[1])
        end
      when 'week'
        @transactions = @transactions.group("date_trunc('week', date)").sum(:amount).map do |result|
          Transaction.new(date: result[0], memo: nil, amount: result[1])
        end
      when 'category'
        @transactions = @transactions.joins(:category).group(:category).sum(:amount).map do |result|
          display_name = result[0].display_name == 'selecione ..' ? 'S/ categoria' : result[0].display_name 
          Transaction.new(date: nil, memo: display_name, amount: result[1])
        end
      else
        @transactions.order(:date, :memo, :amount)
      end
    end
end

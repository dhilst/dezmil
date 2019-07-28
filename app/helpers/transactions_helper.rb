require 'i18n'

module TransactionsHelper
  def groups
    if session[:groupby].nil? || session[:groupby] == 'ungrouped'
      dftopt = 'agrupar por ...'
    else
      dftopt = 'desagrupar ...'
    end
    options_for_select({
      dftopt => 'ungrouped',
      'dia' => 'day',
      'semana' => 'week',
      'categoria' => 'category'
    }, session[:groupby] || 'ungrouped')
  end

  def categories(transaction)
    cats = current_user.categories.order(:display_name).map do |c|
      selected_attr = transaction.category&.id == c.id ? 'selected' : ''
      "<option value='#{c.id}' class='category-#{c.name}' #{selected_attr} data-color='#{c.color}'>#{c.display_name}</option>\n"
    end.join
    cats
  end
end

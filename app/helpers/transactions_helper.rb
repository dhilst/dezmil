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
      'semana' => 'week'
    }, session[:groupby] || 'ungrouped')
  end
end

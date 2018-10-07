class AddBalanceToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :balance, :decimal
  end
end

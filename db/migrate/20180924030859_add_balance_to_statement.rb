class AddBalanceToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :balance, :decimal
  end
end

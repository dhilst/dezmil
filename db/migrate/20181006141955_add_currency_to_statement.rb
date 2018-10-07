class AddCurrencyToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :currency, :string
    add_column :statements, :bank, :string
  end
end

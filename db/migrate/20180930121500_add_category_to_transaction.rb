class AddCategoryToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :category, foreign_key: true
  end
end

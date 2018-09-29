class AddUniqueIndexToTransactions < ActiveRecord::Migration[5.2]
  def change
		add_index :transactions, %i[date memo amount], unique: true
  end
end

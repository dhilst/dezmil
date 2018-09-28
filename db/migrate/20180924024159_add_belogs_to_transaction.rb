class AddBelogsToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :statement, foreign_key: true
  end
end

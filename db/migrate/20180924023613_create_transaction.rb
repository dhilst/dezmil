class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :memo
      t.decimal :amount
      t.date :date
    end
  end
end

class RenameMaxToAmountInGoals < ActiveRecord::Migration[5.2]
  def change
    rename_column :goals, :max, :amount
  end
end

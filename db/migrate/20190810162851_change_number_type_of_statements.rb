class ChangeNumberTypeOfStatements < ActiveRecord::Migration[5.2]
  def up
    change_column :statements, :number, :string
  end
  def down
    change_column :statements, :number, :decimal
  end
end

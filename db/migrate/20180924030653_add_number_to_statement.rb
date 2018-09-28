class AddNumberToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :number, :number
  end
end

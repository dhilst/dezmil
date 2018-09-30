class AddDisplayNameToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :display_name, :string
    add_index :categories, %i[name], unique: true
  end
end

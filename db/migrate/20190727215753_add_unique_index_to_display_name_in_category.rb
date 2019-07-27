class AddUniqueIndexToDisplayNameInCategory < ActiveRecord::Migration[5.2]
  def change
    add_index :categories, [:user_id, :display_name], unique: true
  end
end

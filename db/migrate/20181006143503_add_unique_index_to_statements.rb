class AddUniqueIndexToStatements < ActiveRecord::Migration[5.2]
  def change
    add_index :statements, %i[number balance user_id date currency bank], unique: true, name: 'unique_by_all'
  end
end

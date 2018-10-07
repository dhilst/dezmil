class AddPostedAtToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :date, :datetime
  end
end

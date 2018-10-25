class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.references :category, foreing_key: true
      t.references :user, foreing_key: true
      t.decimal :max
      t.index %i[category_id user_id], unique: true
      t.timestamps
    end
  end
end

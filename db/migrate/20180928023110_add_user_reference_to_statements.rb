class AddUserReferenceToStatements < ActiveRecord::Migration[5.2]
  def change
		add_reference :statements, :user, foreing_key: true
  end
end

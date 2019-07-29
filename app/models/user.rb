class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable

	has_many :statements
	has_many :transactions, through: :statements
  has_many :goals

  def categories
    name = Category.arel_table[:name]
    Category
      .where(user_id: [nil, id])
      .where(name.not_eq('uncategorized').or(name.eq(nil)))
  end

  def custom_categories
    Category.where(user_id: self.id)
  end
end

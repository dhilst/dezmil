class Category < ApplicationRecord
  # rails already devine transaction method
  has_one :transaction_, foreign_key: :category_id
  has_one :user, foreign_key: :user_id

  validates :display_name, presence: true
  validates :color, presence: true
end

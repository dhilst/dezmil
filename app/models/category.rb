class Category < ApplicationRecord
  # rails already devine transaction method
  has_one :transaction_, foreign_key: :category_id
  has_one :user, foreign_key: :user_id
end

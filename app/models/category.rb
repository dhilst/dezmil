class Category < ApplicationRecord
  # rails already devine transaction method
  has_one :transaction_, foreign_key: :category_id 
end

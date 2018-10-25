class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :user, uniqueness: { scope: %i[category] }
end

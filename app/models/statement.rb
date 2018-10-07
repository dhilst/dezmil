class Statement < ApplicationRecord
	belongs_to :user
	has_many :transactions, dependent: :destroy
  validates :number, uniqueness: {scope: %i[balance user_id date currency bank]}
end

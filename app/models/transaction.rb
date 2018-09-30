class Transaction < ApplicationRecord
	belongs_to :statement
	validates :memo, uniqueness: { scope: %i[date amount] }
	scope :month, -> (d) { where(date: d.beginning_of_month..d.end_of_month) }
end

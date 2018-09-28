class Transaction < ApplicationRecord
	belongs_to :statement
	validates :memo, uniqueness: { scope: %i[date amount] }
end

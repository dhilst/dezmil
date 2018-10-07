class Transaction < ApplicationRecord
  belongs_to :statement
  validates :memo, uniqueness: { scope: %i[date amount] }
  scope :month, -> (d) { where('transactions.date' => d.beginning_of_month..d.end_of_month) }
  belongs_to :category, optional: true
  scope :agrep, -> (pattern, ratio) {
    where('length(memo) - levenshtein(lower(memo),lower(:pattern)) > length(:pattern) * :ratio', pattern: pattern, ratio: ratio)
  }

  def debit
    amount <= 0 ? amount : nil
  end

  def credit
    amount > 0 ? amount : nil
  end
end

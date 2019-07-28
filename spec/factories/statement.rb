FactoryBot.define do
  factory :statement do
    user
    number { Faker::Bank.account_number.to_s }
    balance { Faker::Number }
    date { DateTime.now }
  end
end

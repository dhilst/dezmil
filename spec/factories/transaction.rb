FactoryBot.define do
  factory :transaction do
    memo { Faker::String.random }
    amount { Faker::Number.number }
    date { DateTime.now }
    association :statement
    balance { Faker::Number.number }
  end
end

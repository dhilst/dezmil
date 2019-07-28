FactoryBot.define do
  factory :transaction do
    memo { Faker::String.random(10) }
    amount { Faker::Number.number(10) }
    date { DateTime.now }
    association :statement 
    balance { Faker::Number.number(10) }
  end
end

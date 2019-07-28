# This will guess the User class
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    confirmed_at { DateTime.now }
  end
end

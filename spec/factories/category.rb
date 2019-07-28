FactoryBot.define do
  factory :category do
    color { "#aabbcc" }
    user_id { nil }

    trait :uncategorized do
      display_name { 'Uncategorized' }
      name { 'uncategorized' }
      id { 1 }
      user_id { nil }
    end

    after :build do |cat| material = Faker::Commerce.unique.material
      cat.name ||= material
      cat.display_name ||= material
    end
  end
end

FactoryBot.define do
  factory :project do
    name { Faker::Commerce.product_name }
    user
  end
end

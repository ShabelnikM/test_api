FactoryBot.define do
  factory :task do
    name { Faker::Commerce.product_name }
    deadline { Time.now + rand(1..30).days + rand(1..24).hours + rand(1..360).minutes }
    done { [true, false][rand(0..1)] }
    priority { 0 }
    project
  end
end

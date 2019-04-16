FactoryBot.define do
  factory :user do
    email    { Faker::Internet.email }
    username { Faker::Name.name }
    password { SecureRandom.urlsafe_base64(8) }
    password_confirmation { password }
  end
end

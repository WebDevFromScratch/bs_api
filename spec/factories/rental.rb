FactoryGirl.define do
  factory :rental do
    name { Faker::Address.street_address }
    daily_rate 10
  end
end

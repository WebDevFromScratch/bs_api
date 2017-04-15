FactoryGirl.define do
  factory :booking do
    start_at 1.day.from_now
    end_at 2.days.from_now
    client_email { Faker::Internet.email }
    price 10

    association :rental
  end
end

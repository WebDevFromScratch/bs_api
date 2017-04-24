require 'faker'

2.times do
  Rental.create(
    name: Faker::Address.street_address,
    daily_rate: rand(10..100)
  )
end

Rental.all.each do |rental|
  Booking.create(
    rental_id: rental.id,
    start_at: 5.days.from_now,
    end_at: 10.days.from_now,
    client_email: Faker::Internet.email,
    price: 5.times { rental.daily_rate }
  )
end

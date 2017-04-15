require 'rails_helper'

describe Booking do
  describe 'validations:' do
    it 'is invalid without an associated Rental' do
      booking = build :booking, rental: nil

      expect(booking).not_to be_valid
      expect(booking.errors[:rental]).to include 'must exist'
    end

    it 'is invalid without start_at' do
      booking = build :booking, start_at: nil

      expect(booking).not_to be_valid
      expect(booking.errors[:start_at]).to contain_exactly 'can\'t be blank'
    end

    it 'is invalid with start_at in the past' do
      booking = build :booking, start_at: 1.day.ago

      expect(booking).not_to be_valid
      expect(booking.errors[:start_at]).to contain_exactly 'can\'t be in the past'
    end

    it 'is invalid without end_at' do
      booking = build :booking, end_at: nil

      expect(booking).not_to be_valid
      expect(booking.errors[:end_at]).to contain_exactly 'can\'t be blank'
    end

    it 'is invalid when end_at is on the same day or before start_at' do
      booking = build :booking, start_at: 1.day.from_now, end_at: 1.day.from_now

      expect(booking).not_to be_valid
      expect(booking.errors[:end_at]).to contain_exactly 'must be after start_at'
    end

    it 'is invalid if dates overlap with an existing booking for a given rental' do
      rental = create :rental
      create :booking, rental: rental, start_at: 2.days.from_now, end_at: 4.days.from_now
      booking = build :booking, rental: rental, start_at: 1.day.from_now, end_at: 2.days.from_now

      expect(booking).not_to be_valid
      expect(booking.errors[:base]).to contain_exactly 'already booked for selected dates'
    end

    it 'is invalid without client_email' do
      booking = build :booking, client_email: nil

      expect(booking).not_to be_valid
      expect(booking.errors[:client_email]).to include 'can\'t be blank'
    end

    it 'is invalid with invalid client_email' do
      booking = build :booking, client_email: 'not email'

      expect(booking).not_to be_valid
      expect(booking.errors[:client_email]).to contain_exactly 'is invalid'
    end

    it 'is invalid without price' do
      booking = build :booking, price: nil

      expect(booking).not_to be_valid
      expect(booking.errors[:price]).to contain_exactly 'can\'t be blank'
    end

    it 'is valid with valid attributes' do
      booking = build :booking

      expect(booking).to be_valid
    end
  end
end

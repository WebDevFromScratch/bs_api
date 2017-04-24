class CalculateBookingPrice
  def initialize(start_at:, end_at:, rental_id:)
    @start_at = start_at
    @end_at = end_at
    @rental_id = rental_id
  end

  def call
    return nil unless (rental && start_at && end_at) # NOTE: consider returning a true error object instead
    rental.daily_rate * booking_length_in_nights
  end

  private

  attr_reader :start_at, :end_at, :rental_id

  def rental
    @rental ||= Rental.find_by(id: rental_id)
  end

  def booking_length_in_nights
    end_at.to_date - start_at.to_date
  end
end

class BookingsController < ApplicationController
  def index
    bookings = Booking.where(rental_id: params[:rental_id])
    render json: bookings
  end

  def show
    booking = find_booking
    render json: booking
  end

  def create
    rental = find_rental
    booking = Booking.new(
      booking_params.merge({ price: calculate_price, rental_id: rental.id })
    )

    rental.with_lock { booking.save }

    if booking.errors.any?
      render json: booking.errors, status: :unprocessable_entity
    else
      render json: booking, status: :created
    end
  end

  def update
    rental = find_rental
    booking = find_booking

    rental.with_lock { booking.update(booking_params.merge(price: calculate_price)) }

    if booking.errors.any?
      render json: booking.errors, status: :unprocessable_entity
    else
      render json: booking, status: :ok
    end
  end

  def destroy
    booking = find_booking
    booking.destroy
  end

  private

  def find_booking
    Booking.find(params[:id])
  end

  def find_rental
    Rental.find(params[:rental_id])
  end

  def booking_params
    params.require(:booking).permit(
      :start_at, :end_at, :client_email
    )
  end

  def calculate_price
    CalculateBookingPrice.new(
      start_at: booking_params[:start_at],
      end_at: booking_params[:end_at],
      rental_id: params[:rental_id]
    ).call
  end
end

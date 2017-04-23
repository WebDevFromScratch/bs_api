class RentalsController < ApplicationController
  def index
    # NOTE: paginate as the next step, probably
    rentals = Rental.all
    render json: rentals
  end

  def show
    rental = find_rental
    render json: rental
  end

  def create
    rental = Rental.new(rental_params)

    if rental.save
      render json: rental, status: :created
    else
      render json: rental.errors, status: :unprocessable_entity
    end
  end

  def update
    rental = find_rental

    if rental.update(rental_params)
      render json: rental, status: :ok
    else
      render json: rental.errors, status: :unprocessable_entity
    end
  end

  def destroy
    rental = find_rental
    rental.destroy
  end

  private

  def find_rental
    Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:name, :daily_rate)
  end
end

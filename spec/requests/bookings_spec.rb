require 'rails_helper'

describe 'Bookings API', type: :request do
  let(:rental) { create :rental }

  describe 'GET rentals/:rental_id/bookings' do
    it 'returns a list or bookings' do
      create :booking, rental: rental
      create :booking, rental: rental, start_at: 20.days.from_now, end_at: 30.days.from_now

      get rental_bookings_path(rental_id: rental.id), headers: token_header

      expect(json_response['data'].count).to eq 2
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /rentals/:rental_id/bookings/:id' do
    it 'returns a booking, when booking is found' do
      booking = create :booking, client_email: 'john@wherever.com'

      get rental_booking_path(rental_id: rental.id, id: booking.id), headers: token_header

      expect(json_response['data']['attributes']['client-email']).to eq 'john@wherever.com'
      expect(response).to have_http_status(200)
    end

    it 'retuns not found response, when booking is not found' do
      get rental_booking_path(rental_id: rental.id, id: 1234), headers: token_header

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /rentals/:rental_id/bookings' do
    it 'creates a new booking and responds with success response, when right params passed' do
      booking_params = {
        start_at: 2.days.from_now,
        end_at: 3.days.from_now,
        client_email: 'john@wherever.com'
      }

      expect do
        post rental_bookings_path(rental_id: rental.id), params: { booking: booking_params }, headers: token_header
      end.to change { Booking.all.count }.by(1)

      expect(json_response['data']['attributes']['client-email']).to eq 'john@wherever.com'
      expect(json_response['data']['attributes']['price'].to_f).to eq 10
      expect(response).to have_http_status(201)
    end

    it 'does not create a new booking and responds with errors, when incorrect params passed' do
      booking_params = { start_at: 2.days.from_now, end_at: 2.days.from_now }

      expect do
        post rental_bookings_path(rental_id: rental.id), params: { booking: booking_params }, headers: token_header
      end.not_to change { Booking.all.count }

      expect(json_response['client_email']).to include 'can\'t be blank'
      expect(json_response['end_at']).to contain_exactly 'must be after start_at'
      expect(response).to have_http_status(422)
    end
  end

  describe 'PUT/PATCH /rentals/:rental_id/bookings/:id' do
    it 'updates a booking and responds with success response, when right params passed' do
      booking = create :booking, client_email: 'john@wherever.com'
      booking_params = {
        start_at: 12.days.from_now,
        end_at: 14.days.from_now,
        client_email: 'james@wherever.com'
      }

      patch rental_booking_path(rental_id: rental.id, id: booking.id),
            params: { booking: booking_params },
            headers: token_header

      expect(booking.reload.client_email).to eq 'james@wherever.com'
      expect(json_response['data']['attributes']['client-email']).to eq 'james@wherever.com'
      expect(response).to have_http_status(200)
    end

    it 'does not update a booking and responds with errors, when incorrect params passed' do
      booking = create :booking, client_email: 'john@wherever.com'

      patch rental_booking_path(rental_id: rental.id, id: booking.id),
            params: { booking: { client_email: '' } },
            headers: token_header

      expect(booking.reload.client_email).to eq 'john@wherever.com'
      expect(json_response['client_email']).to include 'can\'t be blank'
      expect(response).to have_http_status(422)
    end

    it 'retuns not found response, when booking is not found' do
      patch rental_booking_path(rental_id: rental.id, id: 1234),
            params: { booking: { client_email: '' } },
            headers: token_header

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE /rentals/:rental_id/bookings/:id' do
    it 'destroys a booking and returns a correct response' do
      booking = create :booking

      delete rental_booking_path(rental_id: rental.id, id: booking.id), headers: token_header

      expect(Booking.find_by(id: booking.id)).to eq nil
      expect(response).to have_http_status(204)
    end

    it 'retuns not found response, when booking is not found' do
      delete rental_booking_path(rental_id: rental.id, id: 1234), headers: token_header

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end
end

require 'rails_helper'

describe 'Rentals API', type: :request do
  describe 'GET /rentals' do
    it 'returns a list or rentals' do
      2.times { create :rental }

      get rentals_path

      expect(json_response['data'].count).to eq 2
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /rentals/:id' do
    it 'returns a rental, when rental is found' do
      rental = create :rental, name: 'Aloha Villa'

      get rental_path(rental)

      expect(json_response['data']['attributes']['name']).to eq 'Aloha Villa'
      expect(response).to have_http_status(200)
    end

    it 'retuns not found response, when rental is not found' do
      get rental_path(1234)

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /rentals' do
    it 'creates a new rental and responds with success response, when right params passed' do
      rental_params = { name: 'Aloha Villa', daily_rate: 50 }

      expect do
        post rentals_path, params: { rental: rental_params }
      end.to change { Rental.all.count }.by(1)

      expect(json_response['data']['attributes']['name']).to eq 'Aloha Villa'
      expect(response).to have_http_status(201)
    end

    it 'does not create a new rental and responds with errors, when incorrect params passed' do
      rental_params = { name: '', daily_rate: 50 }

      expect do
        post rentals_path, params: { rental: rental_params }
      end.not_to change { Rental.all.count }

      expect(json_response['name']).to contain_exactly 'can\'t be blank'
      expect(response).to have_http_status(422)
    end
  end

  describe 'PUT/PATCH /rentals/:id' do
    it 'updates a rental and responds with success response, when right params passed' do
      rental = create :rental, name: 'Aloha Villa'

      patch rental_path(rental), params: { rental: { name: 'Aloha Mansion' } }

      expect(rental.reload.name).to eq 'Aloha Mansion'
      expect(json_response['data']['attributes']['name']).to eq 'Aloha Mansion'
      expect(response).to have_http_status(200)
    end

    it 'does not update a rental and responds with errors, when incorrect params passed' do
      rental = create :rental, name: 'Aloha Villa'

      patch rental_path(rental), params: { rental: { name: '' } }

      expect(rental.reload.name).to eq 'Aloha Villa'
      expect(json_response['name']).to contain_exactly 'can\'t be blank'
      expect(response).to have_http_status(422)
    end

    it 'retuns not found response, when rental is not found' do
      patch rental_path(1234), params: { rental: { name: '' } }

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE /rentals/:id' do
    it 'destroys a rental and returns a correct response' do
      rental = create :rental

      delete rental_path(rental)

      expect(Rental.find_by(id: rental.id)).to eq nil
      expect(response).to have_http_status(204)
    end

    it 'retuns not found response, when rental is not found' do
      delete rental_path(1234)

      expect(json_response['errors']).to eq 'Not found'
      expect(response).to have_http_status(404)
    end
  end
end

require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { result: 'expected response' }
    end
  end

  describe 'access authentication' do
    it 'renders unauthorized when access token header is not present' do
      get :index

      expect(json_response['errors']).to eq 'Unauthorized'
      expect(response.status).to eq 401
    end

    it 'renders unauthorized when wrong access token header is present' do
      @request.headers.merge({ 'Authorization' => 'wrong_token' })
      get :index

      expect(json_response['errors']).to eq 'Unauthorized'
      expect(response.status).to eq 401
    end

    it 'renders an expected response when correct access token header is present' do
      @request.headers.merge(token_header)

      get :index

      expect(json_response['result']).to eq 'expected response'
      expect(response.status).to eq 200
    end
  end
end

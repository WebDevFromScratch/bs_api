module ApiHelper
  def json_response
    JSON.parse(response.body)
  end

  def token_header
    { 'Authorization' => "Token #{Rails.application.secrets.api_access_token}" }
  end
end

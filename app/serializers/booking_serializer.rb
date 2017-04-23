class BookingSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :end_at, :price, :client_email
  belongs_to :rental
end

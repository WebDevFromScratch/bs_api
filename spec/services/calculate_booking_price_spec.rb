describe CalculateBookingPrice do
  describe '#call' do
    it 'returns correct price when rental exists' do
      rental = create :rental, daily_rate: 20
      subject = CalculateBookingPrice.new(
        start_at: 1.day.from_now,
        end_at: 3.days.from_now,
        rental_id: rental.id
      )

      expect(subject.call).to eq 40
    end

    it 'returns nil when rental does not exist' do
      subject = CalculateBookingPrice.new(
        start_at: 1.day.from_now,
        end_at: 3.days.from_now,
        rental_id: 1234
      )

      expect(subject.call).to eq nil
    end
  end
end

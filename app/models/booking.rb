class Booking < ApplicationRecord
  validates :start_at, :end_at, :price, :rental, presence: true
  validates :client_email, presence: true, format: /@/
  validate :start_at_cannot_be_in_the_past
  validate :end_at_cannot_must_be_after_start_at
  validate :dates_do_not_overlap_by_rental

  scope :by_rental_id, -> (rental_id) { where(rental_id: rental_id) }

  belongs_to :rental

  private

  def start_at_cannot_be_in_the_past
    errors.add(:start_at, 'can\'t be in the past') if start_at && start_at < Time.zone.today
  end

  def end_at_cannot_must_be_after_start_at
    if start_at && end_at && end_at.to_date <= start_at.to_date
      errors.add(:end_at, 'must be after start_at')
    end
  end

  def dates_do_not_overlap_by_rental
    # NOTE: this should be somehow also protected with a DB constraint..
    if rental && start_at && end_at &&
      Booking.by_rental_id(rental.id).where(start_at: start_at..end_at)
             .or(Booking.by_rental_id(rental.id).where(end_at: start_at..end_at)).present?

      errors.add(:base, 'already booked for selected dates')
    end
  end
end

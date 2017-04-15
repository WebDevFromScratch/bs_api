class Booking < ActiveRecord::Base
  validates :start_at, :end_at, :price, :rental, presence: true
  validates :client_email, presence: true, format: /@/
  validate :start_at_cannot_be_in_the_past
  validate :end_at_cannot_must_be_after_start_at

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
end

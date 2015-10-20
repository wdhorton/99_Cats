class CatRentalRequest < ActiveRecord::Base
  RENTAL_STATUSES = [ "Pending", "Approved", "Denied" ]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: RENTAL_STATUSES }
  validate :cannot_approve_overlapping_requests

  belongs_to :cat

  def overlapping_requests
    CatRentalRequest.where("cat_id = :cat_id AND (start_date < :end_date AND end_date > :start_date) AND id != :id",
                          { cat_id: cat_id, start_date: start_date, end_date: end_date, id: id })
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "Approved")
  end

  def cannot_approve_overlapping_requests
    if !overlapping_requests.empty?
      errors.add(:start_date, "cannot overlap with approved requests")
    end
  end
end

require 'byebug'
class CatRentalRequest < ActiveRecord::Base
  RENTAL_STATUSES = [ "Pending", "Approved", "Denied" ]

  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: RENTAL_STATUSES }
  validate :cannot_approve_overlapping_requests

  belongs_to :cat


  def overlapping_requests
    query = <<-SQL
      cat_id = :cat_id
      AND (start_date < :end_date AND end_date > :start_date)
      AND (:id IS NULL OR id != :id)
    SQL

    CatRentalRequest.where(query,
      cat_id: cat_id,
      start_date: start_date,
      end_date: end_date,
      id: id
    )
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "Approved")
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "Pending")
  end

  def cannot_approve_overlapping_requests
    if !overlapping_approved_requests.empty? && status == "Approved"
      errors.add(:start_date, "cannot overlap with approved requests")
    end
  end

  def approve!
    CatRentalRequest.transaction do
      # debugger
      update!(status: "Approved")
      overlapping_pending_requests.each(&:deny!)
    end
  end

  def deny!
    update!(status: "Denied")
  end

end

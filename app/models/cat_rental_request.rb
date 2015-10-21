class CatRentalRequest < ActiveRecord::Base
  RENTAL_STATUSES = [ "Pending", "Approved", "Denied" ]

  validates :cat_id, :start_date, :end_date, :status, :requester, presence: true
  validates :status, inclusion: { in: RENTAL_STATUSES }
  validate :cannot_approve_overlapping_requests

  validate :cannot_end_rental_before_it_starts
  validate :cannot_start_rental_before_today

  belongs_to :cat
  belongs_to :requester, class_name: "User", foreign_key: :user_id

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

  def approve!
    CatRentalRequest.transaction do
      update!(status: "Approved")
      overlapping_pending_requests.each(&:deny!)
    end
  end

  def deny!
    update!(status: "Denied")
  end

  def denied?
    status == "Denied"
  end

  private

    def overlapping_approved_requests
      overlapping_requests.where(status: "Approved")
    end

    def overlapping_pending_requests
      overlapping_requests.where(status: "Pending")
    end

    def cannot_approve_overlapping_requests
      return if denied?

      if !overlapping_approved_requests.empty? && status == "Approved"
        errors[:base] << "cannot overlap with approved requests"
      end

    end

    def cannot_end_rental_before_it_starts
      return if start_date < end_date
      errors[:start_date] << "must come before end date"
      errors[:end_date] << "must come before start date"
    end

    def cannot_start_rental_before_today
      return unless id.nil?

      time_diff = start_date <=> Date.today
      if time_diff == -1
        errors[:start_date] << "must be in the present or future"
      end

    end


end

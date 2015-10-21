class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  CAT_COLOR = ["brown", "black", "orange", "calico"]

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: CAT_COLOR }
  validates :sex, inclusion: %w(F M)

  validate :must_be_born_in_the_past

  has_many :cat_rental_requests, dependent: :destroy
  
  def age
    time_ago_in_words(birth_date)
  end

  private

    def must_be_born_in_the_past
      return unless id.nil?

      time_diff = birth_date <=> Date.today
      if time_diff == 1
        errors[:birth_date] << "must be in the past"
      end
    end
end

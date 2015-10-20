class Cat < ActiveRecord::Base
  CAT_COLOR = ["brown", "black", "orange", "calico"]

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: CAT_COLOR }

  has_many :cat_rental_requests
  
  def age
    (Date.current - birth_date).to_i.to_s + " days"
  end
end

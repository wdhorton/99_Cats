class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, presence: true

  def age
    (DateTime.current.to_i - birth_date.to_i).to_s + " seconds" 
  end
end

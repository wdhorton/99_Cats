# require 'bcrypt'

class User < ActiveRecord::Base
  validates :username, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }


  has_many :cats
  has_many :requests, class_name: "CatRentalRequest", foreign_key: :user_id
  has_many :sessions


  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user

    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end

  def password
    @password
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_session_token!
    new_session = self.sessions.new
    new_session.save!
  end



end

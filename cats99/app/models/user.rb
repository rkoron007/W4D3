class User < ApplicationRecord
  validates :user_name, :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true

  after_initialize :ensure_session_token

  attr_reader :password
  def reset_session_token!
    self.session_token = User.generate_token
    self.save!
    self.session_token
  end

  def ensure_session_token
   reset_session_token! if self.session_token.nil?
  end

  def self.generate_token
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && user.is_password?(password)
    nil
  end

end

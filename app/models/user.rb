class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Invalid E-mail' },
    uniqueness: { case_sensitive: false  }
end

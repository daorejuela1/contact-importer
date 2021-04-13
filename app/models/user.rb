class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :csv_uploads
  has_many :contacts
  has_many :contact_errors
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Invalid E-mail' },
    uniqueness: { case_sensitive: false  }
end

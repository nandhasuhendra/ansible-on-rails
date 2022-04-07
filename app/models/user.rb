class User < ApplicationRecord
  before_save { !email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name,  presence: true, length: { maximum: 25 }
  validates :last_name,   presence: true, length: { maximum: 25 }
  validates :username,    presence: true, uniqueness: true, length: { in: 4..25 }
  validates :email,       presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password,              presence: true, length: { in: 6..25 }, confirmation: true, on: :create
  validates :password_confirmation, presence: true, length: { in: 6..25 }, confirmation: true, on: :update, if: :password_changed?

  protected
    def password_changed?
      !password.blank?
    end
end

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  before_save { self.email = email.downcase }
  has_secure_password
  has_many :posts, dependent: :destroy
  validates :username, uniqueness: { case_sensitive: false }, 
    presence: true, length: { minimum: 6, maximum: 25 }
  validates :email, uniqueness: { case_sensitive: false }, 
    presence: true, length: { maximum: 128 }, 
    format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, on: :create
end
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  has_many :posts
  validates :username, uniqueness: { case_sensitive: false }, 
    presence: true, length: {minimum: 6, maximum: 25}
  validates :email, uniqueness: { case_sensitive: false }, 
    presence: true, length: {maximum: 128}, 
    format: { with: VALID_EMAIL_REGEX }
end
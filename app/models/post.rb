class Post < ApplicationRecord
  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  validates :title, presence: true, length: { in: 6..128 }
  validates :description, presence: true, length: { minimum: 6 }
  validates_associated :user
end
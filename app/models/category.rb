class Category < ApplicationRecord
  has_many :post_categories, dependent: :destroy
  has_many :posts, through: :post_categories
  validates :name, uniqueness: true, presence: true, length: { minimum: 3, maximum: 25 }
end
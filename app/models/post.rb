class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { in: 6..128 }
  validates :description, presence: true, length: { minimum: 6 }
end
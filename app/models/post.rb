class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { maximum: 70 }
  validates :body, presence: true, length: { maximum: 300 }

end

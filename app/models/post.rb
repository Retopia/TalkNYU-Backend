class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  validates :title, presence: true
end

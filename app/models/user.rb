class User < ApplicationRecord
  has_secure_password
  has_many :posts
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy


  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end

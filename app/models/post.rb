class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :reactions
  mount_uploader :image, PostImageUploader
  validates :content, presence: true, length: {maximum: 255}
  validates :image, presence: true
end

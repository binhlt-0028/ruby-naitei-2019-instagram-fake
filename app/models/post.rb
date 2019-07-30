class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  scope :create_desc, ->{order created_at: :desc}
  scope :non_block, ->{where non_block: true}
  scope :post_auth, ->(id){where user_id: id}
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  mount_uploader :image, PostImageUploader
  validates :content, presence: true, length: {maximum: 255}
  validates :image, presence: true
end

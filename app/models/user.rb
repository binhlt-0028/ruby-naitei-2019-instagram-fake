class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_reactions, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :active_relationships, class_name: FollowUser.name,
                                  foreign_key: :follower_id,
                                  dependent: :destroy
  has_many :passive_relationships, class_name: FollowUser.name,
                                  foreign_key: :followed_id,
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :notifications, foreign_key: :receiver, dependent: :destroy
  has_many :reverse_notifications, foreign_key: :creator, dependent: :destroy,
              class_name: Notification.name

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email_max},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.name_max}
  validates :password, presence: true, length: {minimum: Settings.pass_min},
                    allow_nil: true

  mount_uploader :avatar, AvatarImageUploader
  before_create :create_activation_token

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def activate
    update_columns activated: true
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_token
    self.activation_token = User.new_token
  end

  def feed
    Post.post_auth id
  end
end

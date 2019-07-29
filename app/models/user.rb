class User < ApplicationRecord
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

  def feed
    Post.post_auth id
  end
end

class Notification < ApplicationRecord
  belongs_to :post
  belongs_to :creator, class_name: User.name
  belongs_to :receiver, class_name: User.name
end

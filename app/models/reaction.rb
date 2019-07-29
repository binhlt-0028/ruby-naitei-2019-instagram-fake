class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum type_id_enum: [
    :fa_thumbs_up,
    :fa_smile_beam,
    :fa_kiss_wink_heart,
    :fa_sad_tear,
    :fa_angry
  ]
end

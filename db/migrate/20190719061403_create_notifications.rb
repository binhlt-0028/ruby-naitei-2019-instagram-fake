class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :type_id
      t.references :post, foreign_key: true
      t.integer :creator_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end

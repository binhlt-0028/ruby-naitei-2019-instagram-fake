class CreateFollowUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_users do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :follow_users, :follower_id
    add_index :follow_users, :followed_id
    add_index :follow_users, [:follower_id, :followed_id], unique: true
  end
end

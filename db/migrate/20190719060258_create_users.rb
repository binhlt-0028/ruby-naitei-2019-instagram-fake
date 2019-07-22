class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :avatar
      t.string :activate_digest
      t.string :reset_degest
      t.string :remeber_digest
      t.boolean :activated
      t.boolean :status

      t.timestamps
    end
  end
end

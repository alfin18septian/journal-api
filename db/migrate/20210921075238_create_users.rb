class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string   :name, null: false
      t.string   :username, null: false, unique: true
      t.string   :email, null: false, unique: true
      t.string   :role, null: false
      t.string   :password_digest, null: false
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      
      t.timestamps
    end
  end
end

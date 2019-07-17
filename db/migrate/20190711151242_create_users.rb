class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 60
      t.string :avatar_link, null: false
      t.string :password_digest, null: false

      t.index :username, unique: true
      t.timestamps
    end
  end
end

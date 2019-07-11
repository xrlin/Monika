class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :commentable, polymorphic: true, index: true
      t.references :users
      t.timestamps
    end
  end
end

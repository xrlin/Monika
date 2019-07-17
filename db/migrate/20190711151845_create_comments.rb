class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :commentable, polymorphic: true, index: true
      t.references :author
      t.references :reply_to_comment, index: true
      t.references :reply_to_user, index: true
      t.integer :root_comment_id
      t.timestamps

      t.index :root_comment_id
    end
  end
end

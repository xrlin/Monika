class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false

       # just to cache votes count
       t.integer :cached_votes_total, default: 0
       t.integer :cached_votes_score, default: 0
       t.integer :cached_votes_up, default: 0
       t.integer :cached_votes_down, default: 0
       t.integer :cached_weighted_score, default: 0
       t.integer :cached_weighted_total, default: 0
       t.float :cached_weighted_average, default: 0.0
    
      t.references :users
      t.timestamps
    end
  end
end

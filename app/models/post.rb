class Post < ApplicationRecord
    acts_as_votable
    acts_as_votable cacheable_strategy: :update_columns
    
    has_many :comments, as: :commentable
    belongs_to :user, class_name: "user", foreign_key: "user_id"
end

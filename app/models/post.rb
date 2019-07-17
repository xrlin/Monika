class Post < ApplicationRecord
    acts_as_votable
    acts_as_votable cacheable_strategy: :update_columns
    
    has_many :comments, as: :commentable
    belongs_to :author, class_name: "User", foreign_key: "author_id"

    validates :content, :author, presence: true

    def identifier
        "#{self.class.name}-#{id}"
    end
end

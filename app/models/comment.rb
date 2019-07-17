class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    belongs_to :author, class_name: "User"
    belongs_to :reply_to_user, class_name: "User", foreign_key: "reply_to_user_id", optional: true
    belongs_to :reply_to_comment, class_name: "Comment", foreign_key: "reply_to_comment_id", optional: true
    # return all comment replys from root comment
    has_many :child_comments, class_name: "Comment", foreign_key: "root_comment_id"
    belongs_to :root_comment, class_name: "Comment", foreign_key: "root_comment_id", optional: true

    validates_presence_of :commentable, :content, message: "can't be blank"
end

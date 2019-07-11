class User < ApplicationRecord
    acts_as_voter
    has_secure_password
    has_many :comments, class_name: "comment", foreign_key: "user_id"
    has_many :posts, class_name: "post", foreign_key: "user_id"
    has_many :articles, class_name: "article", foreign_key: "user_id"
end
class User < ApplicationRecord
    acts_as_voter
    has_secure_password    
    has_many :comments, class_name: "Comment", foreign_key: "user_id"
    has_many :posts, class_name: "Post", foreign_key: "author_id"
    has_many :articles, class_name: "Article", foreign_key: "author_id"
    validates :username, :password_digest, :avatar_link, presence: true
    validates_uniqueness_of :username, message: "must be unique"

    before_validation :set_default_avatar
    
    private

    def set_default_avatar
        return if avatar_link.present?
        self.avatar_link = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562989383747&di=3e40a1ab444f279ed9c08fe6c400e4f6&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F6344eb58ac17d53728736c2f8dd4e843c34558f8.jpg"
    end
end
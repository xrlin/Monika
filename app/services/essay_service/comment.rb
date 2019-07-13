module EssayService
    class Comment
        class << self
            #
            # create comment
            #
            # @param [User] author 
            # @param [String] content 
            # @param [Integer] essay_id 
            # @param [String] essay_type Value is "Post" or "Article", default is "Article"
            # @param [Integer] reply_to_comment_id Default is nil
            #
            # @return [Comment] user error attribute to check whether success
            #
            def create(author, content, essay_id, essay_type = "Article", reply_to_comment_id = nil)
                essay = essay_type == "Post" ? ::Post.find(essay_id) : ::Article.find(essay_id)
                reply_to_comment = reply_to_comment_id.present? ? ::Comment.find(reply_to_comment_id) : nil
                root_comment_id = nil
                reply_to_user = nil
                if reply_to_comment.present?
                    if reply_to_comment.commentable != essay
                        raise Error::BaseError, "reply_comment or essay arguments are wrong"
                    end
                    reply_to_user = reply_to_comment.author
                    root_comment_id = reply_to_comment.root_comment_id
                    root_comment_id = reply_to_comment.id if root_comment_id.nil?
                end
                comment = ::Comment.new(author: author,
                     commentable: essay, reply_to_comment: reply_to_comment, root_comment_id: root_comment_id,
                      content: content, reply_to_user: reply_to_user)
                comment.save
                comment
            end

            #
            # delete comment
            #
            # @param [User] user operating user
            # @param [Integer] comment_id 
            #
            # @return [TrueClass|FalseClass]
            #
            def delete(user, comment_id)
                comment = ::Comment.find(comment_id)
                raise Error::Forbid, "no privilege" unless can_delete?(user, comment)
                comment.delete
            end

            #
            #
            # @param [User] user operator
            # @param [Comment] comment 
            #
            # @return [TrueClass|FalseClass]
            #
            def can_delete?(user, comment)
               return true if comment.author == user
               # @type [Post|Article]
               essay = comment.commentable
               essay.author == user
            end

            #
            # Get essay's comments
            #
            # @param [Integer] essay_id Post or Article id
            # @param [String] essay_type Value is "Post" or "Article", default is "Article"
            # @param [Integer] page
            #
            # @return [ActiveRecord::Relation] <description>
            #
            def comments_with_essay(essay_id, essay_type = "Article", page=1)
                per_page = 20
                ::Comment.where(commentable_id: essay_id, commentable_type: essay_type).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
            end

        end
    end
end
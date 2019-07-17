module EssayService
    class Post
        extend Vote

        class << self
            #
            # Create a post
            #
            # @param [User] author 
            # @param [String] content 
            #
            # @return [Post] 
            #
            def create(author, content)
                post = ::Post.new(author: author, content: content)
                post.save
                post
            end

            #
            # Update post
            #
            # @param [User] author 
            # @param [Integer] postid 
            # @param [String] content 
            #
            # @return [Post] raise Error::Forbid if user has no privilege to update
            #
            def update(user, postid, content)
                post = ::Post.find(postid)
                raise Error::Forbid unless can_update_post?(user, post)
                post.update(content: content)
                post
            end

            #
            # Delete post
            #
            # @param [User] author 
            # @param [Integer] postid 
            #
            # @return [TrueClass|FalseClass] raise Error::Forbid if user has no privilege to delete
            #
            def delete(user, postid)
                post = ::Post.find(postid)
                raise Error::Forbid unless can_delete_post?(user, post)
                post.delete
            end


            #
            # Retrieve post detail
            #
            # @param [Integer] postid
            #
            # @return [Post] 
            #
            def detail(postid)
                ::Post.find(postid)
            end

            #
            # like post
            #
            # @param [Integer] post_id 
            # @param [Integer] user_id
            #
            # @return [Integer] return current score, success if nothing raises
            #
            def like(post_id, user_id)
                post = ::Post.find(post_id)
                user = User.find(user_id)
                like_essay post, user
                post.weighted_score
            end

            #
            # Dislike post
            #
            # @param [Integer] post_id 
            # @param [Integer] user_id
            #
            # @return [Object] success if nothing raises
            #
            def dislike(post_id, user_id)
                post = ::Post.find(post_id)
                user = User.find(user_id)
                dislike_essay post, user
            end

            private

            def can_update_post?(user, post)
                post.author == user
            end

            alias_method :can_delete_post?, :can_update_post?
        end
    end
end
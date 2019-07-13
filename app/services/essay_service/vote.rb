module EssayService
    module Vote

        #
        # Like post or article
        #
        # @param [Post|Article] essay Post or Article object
        # @param [User] user
        #
        # @return
        #
        def like_essay(essay, user)
            user.likes essay
        end

        #
        # Dislike post or article
        #
        # @param [Post|Article] essay Post or Article object
        # @param [User] user
        #
        # @return  raise Error::Forbid if cannot dislike
        #
        def dislike_essay(essay, user)
            raise Error::Forbid, "cannot dislike essay" unless user.voted_for? essay
            user.dislikes essay
        end
    end
end

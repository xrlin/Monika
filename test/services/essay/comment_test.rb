module EssayServiceTest
    class CommentTest < ActiveSupport::TestCase

       test "comment can  deleted by comment author" do
            user  = users(:user1)
            comment = comments(:comment_by_user1)
            assert_nothing_raised do
                EssayService::Comment.delete user, comment.id
            end
       end

       test "comment can  deleted by article|post author" do
            user  = users(:user1)
            comment = comments(:comment_by_user2_in_article_with_user1)
            assert_nothing_raised do
                EssayService::Comment.delete user, comment.id
            end
       end

       test "comment can  deleted by another user (except comment or article|post author)" do
            user  = users(:user3)
            comment = comments(:comment_by_user2_in_article_with_user1)
            assert_raises Error::Forbid do
                EssayService::Comment.delete user, comment.id
            end
        end

       test "create root comment to article" do
            author = users(:user1)
            article = articles(:article_without_comments)
            assert_difference "article.comments.count", +1 do
                ret = EssayService::Comment.create author, "just a comment", article.id
                Rails.logger.debug "create root comment result: #{ret}"
                article.reload
            end
       end
        

        test "reply comment" do
            author = users(:user1)
            reply_comment = comments(:comment_by_user2_in_article_with_user1)
            article = articles(:article_with_user1)
            assert_difference "article.comments.count", +1 do
                comment = EssayService::Comment.create author, "just a comment", article.id, "Article", reply_comment.id
                article.reload
                assert_equal comment.reply_to_user, reply_comment.author
                assert comment.root_comment_id.present?
            end
        end

        test "reply comment failed is reply comment no in article|post with essay_id argument" do
            author = users(:user1)
            reply_comment = comments(:comment_by_user2_in_article_with_user1)
            article = articles(:article_with_user1)
            wrong_article_id = articles(:article1).id
            assert_raises Error::BaseError do
                EssayService::Comment.create author, "just a comment", wrong_article_id, "Article", reply_comment.id
            end
        end
    end
end
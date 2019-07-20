module EssayServiceTest
    class PostTest < ActiveSupport::TestCase

        test "create success" do
           user = users(:user1)
           post = EssayService::Post.create user, "content"
           assert post.errors.blank?
        end

        test "non-author cannot update post" do
            user = users(:user2)
            post = posts(:post_with_user1)
            assert_raises(Error::Forbid) do
               EssayService::Post.update user, post.id, "content"
            end
        end

        test "non-author cannot delete post" do
            user = users(:user2)
            post = posts(:post_with_user1)
            assert_raises(Error::Forbid) do
               EssayService::Post.delete user, post.id
            end
        end

        test "retrieve detail" do
            post = posts(:post_with_user1)
            assert_nothing_raised do
                EssayService::Post.detail post.id
            end
        end

        test "like post success" do
            user = users(:user1)
            post = posts(:post1)
            assert_difference 'post.weighted_score', +1 do
                EssayService::Post.like post.id, user.id
                post.reload
            end
        end

        test "cannot dislike post unless liked before" do
            user = users(:user1)
            post = posts(:post1)
            assert_raises Error::Forbid do
                EssayService::Post.dislike post.id, user.id
                post.reload
            end
        end
        
    end
end
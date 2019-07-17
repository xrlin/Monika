module EssayServiceTest
    class ArticleTest < ActiveSupport::TestCase

        test "create success" do
           user = users(:user1)
           article = EssayService::Article.create user, "title", "content"
           assert article.errors.blank?
        end

        test "non-author cannot update article" do
            user = users(:user2)
            article = articles(:article_with_user1)
            assert_raises (Error::Forbid) do
               EssayService::Article.update user, article.id, "title", "content"
            end
        end

        test "non-author cannot delete article" do
            user = users(:user2)
            article = articles(:article_with_user1)
            assert_raises (Error::Forbid) do
               EssayService::Article.delete user, article.id
            end
        end

        test "retrieve detail" do
            article = articles(:article_with_user1)
            assert_nothing_raised do
                EssayService::Article.detail article.id
            end
        end

        test "partial update title or content" do
            user = users(:user1)
            article = articles(:article_with_user1)
            assert_no_changes "article.content" do
                article = EssayService::Article.update user, article.id, "title change"
            end

            assert_no_changes "article.title" do
                article = EssayService::Article.update user, article.id, "", "content chagne"
            end
        end

        test "like article success" do
            user = users(:user1)
            article = articles(:article1)
            assert_difference 'article.weighted_score', +1 do
                EssayService::Article.like article.id, user.id
                article.reload
            end
        end

        test "cannot dislike article unless liked before" do
            user = users(:user1)
            article = articles(:article1)
            assert_raises Error::Forbid do
                EssayService::Article.dislike article.id, user.id
                article.reload
            end
        end
        
    end
end
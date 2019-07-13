module EssayService
    class Article
        extend Vote

        class << self
            #
            # Create an article
            #
            # @param [User] author 
            # @param [String] title 
            # @param [String] content 
            #
            # @return [Article] 
            #
            def create(author, title, content)
                article = ::Article.new author: author, title: title, content: content
                article.save
                article
            end

            #
            # Update article
            #
            # @param [User] user 
            # @param [Integer] article_id 
            # @param [String] title  blank will ommit this attribute update
            # @param [String] content blank will omit this attribute update
            #
            # @return [Article] raise Error::Forbid if user has no privilege to update
            #
            def update(user, article_id, title="", content="")
                article = ::Article.find(article_id)
                raise Error::Forbid unless can_update_article?(user, article)
                title = title.blank? ? article.title : title
                content = content.blank? ? article.content : content
                article.update(title: title, content: content)
                article
            end

            #
            # Delete article
            #
            # @param [User] user 
            # @param [Integer] article_id 
            #
            # @return [TrueClass|FalseClass] raise Error::Forbid if user has no privilege to update
            #
            def delete(user, article_id)
                article = ::Article.find(article_id)
                raise Error::Forbid unless can_delete_article? user, article
                article.delete
            end

            #
            # Retrieve article details
            #
            # @param [Integer] article_id 
            #
            # @return [Article] 
            #
            def detail(article_id)
                ::Article.find article_id
            end

            #
            # Like article
            #
            # @param [Integer] article_id 
            # @param [Integer] user_id 
            #
            # @return [Object] success if nothing raises
            #
            def like(article_id, user_id)
                article = ::Article.find article_id
                user = User.find user_id
                like_essay article, user
            end

            #
            # Dislike article
            #
            # @param [Integer] article_id 
            # @param [Integer] user_id 
            #
            # @return [Object] success if nothing raises
            #
            def dislike(article_id, user_id)
                article = ::Article.find article_id
                user = User.find user_id
                dislike_essay article, user
            end

            #
            #
            # @param [Integer] page default 1
            #
            # @return [ActiveRecord::Relation] Set of articles
            #
            def retrieve_articles_with_latest_comments(page = 1)
                per_page = 25
                ::Article.includes(:comments).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
            end

            private
 
            def can_update_article?(user, article)
                article.author == user
            end

            alias_method :can_delete_article?, :can_update_article?
        end
    end
end
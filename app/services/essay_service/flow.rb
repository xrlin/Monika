module EssayService
    class Flow

        class << self

            def index_flow(page = 1)
                retrieve_articles_with_latest_comments(page=1)
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

        end
    end
end
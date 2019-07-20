module EssayService
  class Flow

    class << self

      # 返回根据点赞数逆序分页的结果及每条记录对应的最新3条评论
      # @param [Integer] page
      # @param [Integer] per_page default 5
      # @return [Hash]
      def retrieve_activities(page, per_page=5)
        page = (page.present? ? page : 1).to_i
        essays = retrieve_activities_page page, per_page
        comment_groups = top3comments essays
        {essays: essays, comment_groups: comment_groups}
      end

      # 返回根据点赞逆序的一页article/post记录
      # @param [Integer] page
      # @param [Integer] per_page
      # @return [Array]
      def retrieve_activities_page(page, per_page)
        offset = per_page * (page - 1)
        conn = ActiveRecord::Base.connection
        sql = %Q(
          select * from (select id, title, content, 'article' as essay_type, author_id, created_at, cached_weighted_score from articles
          union all
          select id, NULL as title, content, 'post' as essay_type, author_id, created_at, cached_weighted_score from posts)
            as tmp order by cached_weighted_score desc, created_at desc offset #{conn.quote(offset)} limit #{conn.quote(per_page)}
        )

        rows = conn.execute sql
        ret = []
        rows.each do |row|
          if row['essay_type'] == 'article'
            row.delete 'essay_type'
            tmp = ::Article.new
            tmp.assign_attributes row
          else
            row.delete 'essay_type'
            row.delete 'title'
            tmp = ::Post.new
            tmp.assign_attributes row
          end
          ret << tmp
        end
        ret
      end

      def top3comments(essays)
        top_n_comments essays, 3
      end

      def top_n_comments(essays, top_n)
        essay_arr = essays.map {|essay| "#{essay.class.name}-#{essay.id}"}
        sql = %Q( SELECT comment_ranks.* FROM (
          SELECT comments.*, CONCAT(commentable_type, '-', commentable_id) as group_str,
          rank() OVER (
              PARTITION BY commentable_type, commentable_id
              ORDER BY created_at DESC
          )
          FROM comments
          ) comment_ranks WHERE RANK < :top_n AND comment_ranks.group_str IN (:identifiers_str);
        )
        sql_params = {top_n: top_n + 1}
        sql_params[:identifiers_str] = essay_arr

        comments = ::Comment.includes(:author, :reply_to_user).find_by_sql [sql, sql_params]
        comments.group_by {|comment| "#{comment.commentable_type}-#{comment.commentable_id}"}
      end

      def retrieve_articles_with_latest_comments(page = 1)
        per_page = 5
        essays = ::Article.includes(:author).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
        comment_groups = top3comments essays
        {essays: essays, comment_groups: comment_groups}
      end

      def retrieve_posts_with_latest_comments(page = 1)
        per_page = 5
        essays = ::Post.includes(:author).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
        comment_groups = top3comments essays
        {essays: essays, comment_groups: comment_groups}
      end

      def retrieve_articles_with_user(user, page = 1)
        per_page = 5
        essays = ::Article.includes(:author).where(author_id: user.id).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
        {essays: essays, comment_groups: top3comments(essays)}
      end

      def retrieve_posts_with_user(user, page = 1)
        per_page = 5
        essays = ::Post.includes(:author).where(author_id: user.id).order(id: :desc).offset(per_page * (page - 1)).limit(per_page)
        {essays: essays, comment_groups: top3comments(essays)}
      end

      # 返回用户最近点赞的article/post及最新3条评论信息
      def retrieve_user_activities(user, page = 1, per_page=5)
        offset = per_page * (page - 1)
        sql = %Q(SELECT votes.votable_id, votes.votable_type from votes INNER JOIN (
                 SELECT id FROM votes WHERE voter_id = #{user.id} ORDER BY id DESC OFFSET #{offset} LIMIT #{per_page}) AS v USING(id);

        )
        result = ActiveRecord::Base.connection.execute(sql).to_a
        article_ids = []
        post_ids = []
        result.each do |row|
          if row['votable_type'] == "Post"
            post_ids << row['votable_id']
          elsif row['votable_type'] == "Post"
            article_ids << row['votable_id']
          end
        end
        articles = ::Article.includes(:author).where(id: article_ids).to_a
        posts = ::Post.includes(:author).where(id: post_ids).to_a
        essays = []

        result.each do |row|
          if row['votable_type'] == "Post"
            essays += posts.select {|post| post.id == row['votable_id']}
          elsif row['votable_type'] == "Article"
            essays += articles.select {|post| post.id == row['votable_id']}
          end
        end
        {essays: essays, comment_groups: top3comments(essays)}
      end

    end
  end
end
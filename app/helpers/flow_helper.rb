module FlowHelper
  def essay_path essay
    if essay.class.name == "Post"
      post_path essay
    else
        article_path essay
    end
  end

  def essay_badge_str essay
    essay.class.name == 'Post' ? '随笔' : '文章'
  end

  def edit_essay_path essay
    if essay.class.name == "Post"
      edit_post_path essay
    else
      edit_article_path essay
    end
  end

  def can_delete_essay? essay
    return false if current_user.nil?
    if essay.is_a? Post
       EssayService::Post.can_delete_post? current_user, essay
    else
       EssayService::Article.can_delete_article? current_user, essay
    end
  end

  def can_update_essay? essay
    can_delete_essay? essay
  end


end

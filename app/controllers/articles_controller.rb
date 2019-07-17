class ArticlesController < ApplicationController
  before_action :check_login, except: [:show]
  def show
    @article = EssayService::Article.detail params[:id]
    comment_group = EssayService::Flow.topNcomments [@article], 5
    comments = comment_group.fetch @article.identifier, []
    render locals: {comments: comments}
  end

  def edit
    @article = EssayService::Article.detail params[:id]
  end

  def new
    @article = Article.new
  end

  def create
    title, content = params.require [:title, :content]
    @article = EssayService::Article.create current_user, title, content
    if @article.errors.present?
      flash.now[:error] = @article.errors.full_messages.to_sentence
      render :new
      return
    end
    redirect_to @article
  end

  def update
    title, content = params.require [:title, :content]
    @article = EssayService::Article.update current_user, params[:id], title, content
    if @article.errors.present?
      flash.now[:error] = @article.errors.full_messages.to_sentence
      render :edit
      return
    end
    redirect_to @article
  end

  def destroy

  end
end

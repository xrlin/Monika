class PostsController < ApplicationController
  before_action :check_login, except: [:show]
  def show
    @post = EssayService::Post.detail params[:id]
    comment_group = EssayService::Flow.topNcomments [@post], 5
    comments = comment_group.fetch @post.identifier, []
    render locals: {comments: comments}
  end

  def edit
    @post = EssayService::Post.detail params[:id]
  end

  def new
    @post = Post.new
  end

  def create
    content = params.require [:content][0]
    @post = EssayService::Post.create current_user, content
    if @post.errors.present?
      flash.now[:error] = @post.errors.full_messages.to_sentence
      render :new
      return
    end
    redirect_to @post
  end

  def update
    content = params.require [:content][0]
    @post = EssayService::Post.update current_user, params[:id], content
    if @post.errors.present?
      flash.now[:error] = @post.errors.full_messages.to_sentence
      render :edit
      return
    end
    redirect_to @post
  end

  def destroy

  end
end

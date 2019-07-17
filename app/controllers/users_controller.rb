class UsersController < ApplicationController
  before_action :check_login, only: [:edit, :update]

  def show
    page = (params[:page] || 1).to_i
    user = User.find params[:id]
    if params[:type] == 'post'
      infos = EssayService::Flow.retrieve_posts_with_user user, page

    elsif params[:type] == 'article'
      infos = EssayService::Flow.retrieve_posts_with_user user, page
    else
      infos = EssayService::Flow.retrieve_articles_with_user user, page
    end
    respond_to do |format|
      format.html {
        render locals: {user: user, essays: infos[:essays], comment_groups: infos[:comment_groups], next_page: page + 1}
      }
      format.json {
        render json: {
            html: render_to_string(
                partial: 'flow/index',
                formats: :html,
                layout: false,
                locals: {essays: infos[:essays], comment_groups: infos[:comment_groups], next_page: page + 1}
            )
        }
      }
    end
  end

  def new

  end

  def edit
    if current_user.id != params[:id]&.to_i
      redirect_to '/login'
      return
    end
    @user = current_user
  end

  def update
    update_params = params.permit(:username, :old_password, :new_password, :password_confirmation)
    @user = UserService::Profile.update_profile current_user, **update_params.to_h.deep_symbolize_keys
    if @user.errors.present?
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit
      return
    end
    redirect_to @user
  end

  def create
    arguments = params.permit(:username, :password, :password_confirmation)
    @user = UserService::Register.new(**arguments.to_h.deep_symbolize_keys).perform
    if @user.errors.blank?
      session[:user_id] = @user.id
      redirect_back fallback_location: @user
      return
    end
    flash.now[:error] = @user.errors.full_messages.to_sentence
    render :new
  end
end

class ApplicationController < ActionController::Base
  helper_method :current_user

  protected

  def current_user
    return nil if session[:user_id].blank?
    @current_user ||= User.find session[:user_id]
  end

  # @param [User] user
  def login_user(user)
    session[:user_id] = user.id
  end

  def check_login
    return if current_user.present?
    respond_to do |format|
      format.html {
        redirect_to '/login'
      }
      format.json {
        render json: {
            error: '请先登录',
        }
      }
    end
  end

  def get_nullable_param(key, default=nil)
    return default if params[key].blank? || params[key].to_s.downcase == 'null'
    params[key]
  end
end

class SessionsController < ApplicationController
  def new

  end

  def create
    username, password = params.require([:username, :password])
    user = UserService::Auth.new(username, password).perform
    if user == nil
      flash.now[:error] = "用户名或密码错误"
      render :new
    else
      login_user user
      redirect_to root_path
    end
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end
end

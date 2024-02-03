class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(login_name: session_params[:login_name])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:login_name, :password)
  end
end

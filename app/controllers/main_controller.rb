class MainController < ApplicationController
  include DoorkeeperApiV1
  skip_filter :auto_authenticate_omniauth_user!

  # def index
  #  @me = get_me
  #  @roles = get_roles
    #@microposts = get_microposts
  # end

  def delete
    result = delete_session
    if current_user
      @user = current_user
    else
      @user = User.find_by_id(session[:user_id])
    end
    sign_out @user
    @user.admin_roles.destroy
    @user.destroy
    redirect_to root_url, notice: "Session Close: #{result.inspect}"
  rescue OAuth2::Error
    redirect_to root_url, alert: "Delete Session error"
  end

  def salons
    result = get_salons
    @a = result
    puts @a
      redirect_to root_path, notice: "Funziona API Salons"
  rescue OAuth2::Error
    redirect_to root_url, alert: "Delete Session error"
  end

  def me
    result = get_me
    @a = result
    puts @a
    redirect_to root_path, notice: "Funziona API ME"
  rescue OAuth2::Error
    redirect_to root_url, alert: "Delete Session error"
  end
end

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # https://github.com/plataformatec/devise/issues/2432
    protect_from_forgery except: :doorkeeper
    skip_filter :auto_authenticate_omniauth_user!, only: :doorkeeper

    def doorkeeper
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      raw_info = request.env['omniauth.strategy'].raw_info
      roles = raw_info['roles_for_application']
      oauth_data = request.env['omniauth.auth']
      if roles.empty?
        redirect_to root_url, :alert => 'Il tuo utente non può usare questa applicazione!'
      else
        @user = User.find_or_create_for_doorkeeper_oauth(oauth_data, roles)
        session[:doorkeeper_token] = oauth_data['credentials']['token']
        session[:user_id] = @user.id
        current_user = @user

        if @user.persisted?
          sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
          if is_navigational_format?
            set_flash_message(:notice, :success, kind: ENV['DOORKEEPER_APP_NAME'] || 'Doorkeeper')
            # hide flash message after auto sign in
            #flash.delete(:notice)
          end
        else
          session['devise.doorkeeper_data'] = request.env['omniauth.auth']
          if respond_to?(:new_user_registration_url)
            redirect_to new_user_registration_url
          else
            redirect_to root_url
          end
        end
      end
    end

    def after_omniauth_failure_path_for(scope)
      if respond_to?(:new_session_path)
        new_session_path(scope)
      else
        root_path
      end
    end
  end
end
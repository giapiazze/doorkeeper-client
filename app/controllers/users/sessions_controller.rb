module Users
  class SessionsController < Devise::SessionsController

    def destroy
      super
      cookies.clear(:domain => :all)
    end
  end
end
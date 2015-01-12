module DoorkeeperApiV1

  private

  def access_token
    return @access_token if defined?(@access_token)
    config = Devise.omniauth_configs[:doorkeeper]
    strategy = config.strategy_class.new(*config.args)
    token = session[:doorkeeper_token]
    @access_token = OAuth2::AccessToken.new(strategy.client, token)
  end

  def get_me
    access_token.get("/api/v1/me.json").parsed
  end

  def get_roles
    access_token.get("/api/v1/roles.json").parsed
  end

  def get_salons
    access_token.get("/api/v1/salons.json").parsed
  end

  def delete_session
    # access_token.get("/api/v1/delete").parsed
    access_token.get("/oauth/token/info").parsed
  end
end

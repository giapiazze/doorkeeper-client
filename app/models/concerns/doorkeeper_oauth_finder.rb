module DoorkeeperOauthFinder
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_for_doorkeeper_oauth(oauth_data, admin_roles)
      uid = oauth_data.uid.to_s
      id = uid.to_i
      provider = oauth_data.provider
      user = User.where(provider: provider, uid: uid).first

      if user
        user.name = oauth_data.info.name
        user.email = oauth_data.info.email
        admin_roles.each do |r|
          role = Admin::Role.find_by_id(r['id'])
          if !role
            role = Admin::Role.create!({
                                           id: r['id'],
                                           name: r['name'],

                                       })
            role.save
          end
          if !user.admin_roles.find_by_id(role.id)
            user.admin_roles << role
          end
        end
        user.save! if user.changed?
      else
        user = self.create!({
                                id: id, # use same id
                                name: oauth_data.info.name,
                                provider: oauth_data.provider,
                                uid: uid,
                                email: oauth_data.info.email,
                                #password: Devise.friendly_token[0,20]
                            })
        admin_roles.each do |r|
          role = Admin::Role.find_by_id(r['id'])
          if !role
            role = Admin::Role.create!({
                                           id: r['id'],
                                           name: r['name'],

                                       })
            role.save
          end
          if !user.admin_roles.find_by_id(role.id)
            user.admin_roles << role
          end
        end
        user.save
      end
      user
    end
  end
end

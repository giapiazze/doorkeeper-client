class User < ActiveRecord::Base
  has_and_belongs_to_many :admin_roles, :class_name => 'Admin::Role'
  devise :omniauthable, omniauth_providers: [:doorkeeper]
  devise :timeoutable
  include DoorkeeperOauthFinder

  def admin?
    self.admin_roles.include?(Admin::Role.find(3))
  end

  def op?
    self.admin_roles.include?(Admin::Role.find(4))
  end
end

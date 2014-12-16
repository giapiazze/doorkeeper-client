# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_roles_user, :class => 'Admin::RolesUsers' do
    user nil
    role nil
  end
end

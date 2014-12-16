class CreateAdminRolesUsers < ActiveRecord::Migration
  def change
    create_table :admin_roles_users, id: false do |t|
      t.references :user, index: true, primary: true
      t.references :role, index: true, primary: true

      t.timestamps
    end
  end
end

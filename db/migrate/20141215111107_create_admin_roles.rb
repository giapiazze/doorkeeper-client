class CreateAdminRoles < ActiveRecord::Migration
  def change
    create_table :admin_roles do |t|
      t.string :name

      t.timestamps
    end
    add_index :admin_roles, :id, unique: true
  end
end

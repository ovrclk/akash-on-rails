class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    admin = User.order(id: :asc).first
    admin.update!(admin: true)
  end
end

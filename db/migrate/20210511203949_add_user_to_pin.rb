class AddUserToPin < ActiveRecord::Migration[5.2]
  def change
    Pin.destroy_all
    add_reference :pins, :user, foreign_key: true, null: false
  end
end

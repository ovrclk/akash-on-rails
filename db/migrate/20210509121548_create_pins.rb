class CreatePins < ActiveRecord::Migration[5.2]
  def change
    create_table :pins do |t|
      t.string :title
      t.text :description
      t.string :link
      t.text :image_data

      t.timestamps
    end
  end
end

class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.string :title
      t.string :image
      t.string :description
      t.float :location_lat
      t.float :location_long

      t.timestamps null: false
    end
  end
end

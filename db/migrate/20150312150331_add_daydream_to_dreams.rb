class AddDaydreamToDreams < ActiveRecord::Migration
  def change
    add_column :dreams, :daydream, :boolean
  end
end

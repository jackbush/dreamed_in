class RenameImageToDreamImage < ActiveRecord::Migration
  def change
    rename_column :dreams, :image, :dream_image
  end
end

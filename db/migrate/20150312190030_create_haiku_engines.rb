class CreateHaikuEngines < ActiveRecord::Migration
  def change
    create_table :haiku_engines do |t|

      t.timestamps null: false
    end
  end
end

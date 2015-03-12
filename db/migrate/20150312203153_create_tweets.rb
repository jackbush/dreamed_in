class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :username
      t.string :city
      t.text :tweet

      t.timestamps null: false
    end
  end
end

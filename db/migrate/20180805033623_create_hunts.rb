class CreateHunts < ActiveRecord::Migration
  def change
    create_table :hunts do |t|
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.string :fish_photo
      t.string :fly_photo
      t.string :spot_photo
      t.string :weather_id
      t.string :weather_main
      t.float :temp
      t.float :pressure
      t.float :humidity
      t.float :wind_speed
      t.float :wind_deg
      t.text :memo
      t.timestamps null: false
    end
  end
end

class CreateRiverpoints < ActiveRecord::Migration
  def change
    create_table :riverpoints do |t|
      t.string :riverpoint_number
      t.string :riverpoint_name
      t.decimal :riverpoint_latitude, :precision => 9, :scale => 6
      t.decimal :riverpoint_longitude, :precision => 9, :scale => 6
      t.timestamps null: false
    end
  end
end

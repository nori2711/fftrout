class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :weather_main
      t.string :weather_name
      t.timestamps
    end
  end
end

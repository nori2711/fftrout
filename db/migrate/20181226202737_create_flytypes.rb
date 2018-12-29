class CreateFlytypes < ActiveRecord::Migration
  def change
    create_table :flytypes do |t|
      t.integer :fly_id
      t.string :flyclass
      t.timestamps null: false
    end
  end
end

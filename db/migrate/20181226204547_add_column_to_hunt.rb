class AddColumnToHunt < ActiveRecord::Migration
  def change
    add_column :hunts, :flyclass, :string
  end
end

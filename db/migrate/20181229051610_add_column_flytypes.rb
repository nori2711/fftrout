class AddColumnFlytypes < ActiveRecord::Migration
  def change
    add_column :flytypes, :flyname, :string
  end
end

class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :text
  end
end

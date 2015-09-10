class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :staff_id, :integer
  end
end

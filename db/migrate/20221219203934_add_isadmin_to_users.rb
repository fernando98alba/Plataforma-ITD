class AddIsadminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_admin, :binary
  end
end

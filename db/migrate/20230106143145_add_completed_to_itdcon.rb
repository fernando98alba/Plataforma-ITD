class AddCompletedToItdcon < ActiveRecord::Migration[7.0]
  def change
    add_column :itdcons, :completed, :boolean, default: false
  end
end

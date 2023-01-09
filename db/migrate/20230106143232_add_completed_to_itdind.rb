class AddCompletedToItdind < ActiveRecord::Migration[7.0]
  def change
    add_column :itdinds, :completed, :boolean,  default: false
  end
end

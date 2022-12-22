class AddDescriptionToDat < ActiveRecord::Migration[7.0]
  def change
    add_column :dats, :description, :text
  end
end

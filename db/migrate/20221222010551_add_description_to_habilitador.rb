class AddDescriptionToHabilitador < ActiveRecord::Migration[7.0]
  def change
    add_column :habilitadors, :description, :text
  end
end

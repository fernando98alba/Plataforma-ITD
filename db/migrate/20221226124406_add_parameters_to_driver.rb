class AddParametersToDriver < ActiveRecord::Migration[7.0]
  def change
    add_column :drivers, :min_description, :string
    add_column :drivers, :max_description, :string
    add_column :drivers, :identifier, :string
  end
end

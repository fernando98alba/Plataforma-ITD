class AddParametersToItdcon < ActiveRecord::Migration[7.0]
  def change
    add_column :itdcons, :maturity, :float
    add_column :itdcons, :alignment, :float
  end
end

class AddParametersToItdsin < ActiveRecord::Migration[7.0]
  def change
    add_column :itdsins, :maturity, :float
    add_column :itdsins, :alignment, :float
  end
end

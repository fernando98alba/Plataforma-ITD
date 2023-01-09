class AddParametersToItdcon < ActiveRecord::Migration[7.0]
  def change
    add_column :itdcons, :maturity_score, :float
    add_column :itdcons, :alignment_score, :float
  end
end

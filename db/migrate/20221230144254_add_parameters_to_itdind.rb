class AddParametersToItdind < ActiveRecord::Migration[7.0]
  def change
    add_column :itdinds, :maturity_score, :float
    add_column :itdinds, :alignment_score, :float
  end
end

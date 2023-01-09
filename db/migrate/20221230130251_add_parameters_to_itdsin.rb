class AddParametersToItdsin < ActiveRecord::Migration[7.0]
  def change
    add_column :itdsins, :maturity_score, :float
    add_column :itdsins, :alignment_score, :float
  end
end

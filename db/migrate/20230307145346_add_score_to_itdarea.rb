class AddScoreToItdarea < ActiveRecord::Migration[7.0]
  def change
    add_column :itdareas, :maturity_score, :float
    add_column :itdareas, :alignment_score, :float
  end
end

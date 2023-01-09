class RemoveScoresFromAspiracion < ActiveRecord::Migration[7.0]
  def change
    remove_column :aspiracions, :hab_scores
    remove_column :aspiracions, :dat_scores
  end
end

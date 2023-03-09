class CreateAspiracions < ActiveRecord::Migration[7.0]
  def change
    create_table :aspiracions do |t|
      t.float :hab_scores
      t.float :dat_scores
      t.float :maturity_score
      t.float :alignment_score
      t.references :empresa, null: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end

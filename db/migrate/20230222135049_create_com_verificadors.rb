class CreateComVerificadors < ActiveRecord::Migration[7.0]
  def change
    create_table :com_verificadors do |t|
      t.integer :state
      t.string :comment
      t.references :itdind, foreign_key: true
      t.references :verificador, foreign_key: true
      t.timestamps
    end
  end
end

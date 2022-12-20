class CreateHabilitadors < ActiveRecord::Migration[7.0]
  def change
    create_table :habilitadors do |t|
      t.string :name
      t.references :dat, null: true, foreign_key: true

      t.timestamps
    end
  end
end

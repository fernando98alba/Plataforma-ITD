class CreateAlineamientos < ActiveRecord::Migration[7.0]
  def change
    create_table :alineamientos do |t|
      t.string :name
      t.text :description
      t.text :challenges
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end

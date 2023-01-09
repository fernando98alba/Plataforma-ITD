class CreateEmpresas < ActiveRecord::Migration[7.0]
  def change
    create_table :empresas do |t|
      t.string :name
      t.string :rut
      t.string :sector
      t.integer :income

      t.timestamps
    end
  end
end

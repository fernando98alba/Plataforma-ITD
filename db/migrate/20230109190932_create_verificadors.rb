class CreateVerificadors < ActiveRecord::Migration[7.0]
  def change
    create_table :verificadors do |t|
      
      t.string :name
      t.references :driver, foreign_key: true

      t.timestamps
    end
  end
end

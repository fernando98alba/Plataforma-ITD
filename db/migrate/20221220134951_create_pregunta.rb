class CreatePregunta < ActiveRecord::Migration[7.0]
  def change
    create_table :pregunta do |t|
      t.string :min_description
      t.string :max_descrption
      t.references :driver, null: true, foreign_key: true

      t.timestamps
    end
  end
end

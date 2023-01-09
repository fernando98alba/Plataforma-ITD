class CreateElementos < ActiveRecord::Migration[7.0]
  def change
    create_table :elementos do |t|
      t.string :name
      t.references :habilitador, null: true, foreign_key: true

      t.timestamps
    end
  end
end

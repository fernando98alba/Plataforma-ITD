class CreateIniciativas < ActiveRecord::Migration[7.0]
  def change
    create_table :iniciativas do |t|
      t.string :name
      t.references :madurez, null: true, foreign_key: {on_delete: :cascade}
      t.text :description
      t.text :effort
      t.text :benefict

      t.timestamps
    end
  end
end

class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.string :name
      t.references :empresa, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end

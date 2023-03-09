class CreateBrechas < ActiveRecord::Migration[7.0]
  def change
    create_table :brechas do |t|
      t.references :empresa, null: true, foreign_key: {on_delete: :cascade}
      t.references :iniciativa, null: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end

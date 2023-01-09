class CreateBrechas < ActiveRecord::Migration[7.0]
  def change
    create_table :brechas do |t|
      t.references :empresa, null: true, foreign_key: true
      t.references :iniciativa, null: true, foreign_key: true

      t.timestamps
    end
  end
end

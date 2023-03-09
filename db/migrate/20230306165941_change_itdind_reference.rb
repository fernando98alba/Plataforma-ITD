class ChangeItdindReference < ActiveRecord::Migration[7.0]
  def change
    add_reference :itdinds, :itdarea, null: true, foreign_key: {on_delete: :cascade}
  end
end

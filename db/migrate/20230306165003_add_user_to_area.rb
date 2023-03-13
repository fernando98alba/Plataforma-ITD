class AddUserToArea < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :area, null: true, foreign_key: {on_delete: :cascade}
  end
end

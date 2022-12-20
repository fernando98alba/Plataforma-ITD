class AddDriverToIniciativa < ActiveRecord::Migration[7.0]
  def change
    add_reference :iniciativas, :driver, null: true, foreign_key: true
  end
end

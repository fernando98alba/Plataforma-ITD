class AddItdconToItdind < ActiveRecord::Migration[7.0]
  def change
    add_reference :itdinds, :itdcon, null: true, foreign_key: true
  end
end

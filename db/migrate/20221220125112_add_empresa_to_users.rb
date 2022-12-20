class AddEmpresaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :empresa, null: true, foreign_key: true
  end
end

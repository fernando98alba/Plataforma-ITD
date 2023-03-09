class ChangeColumnNameEmpresas < ActiveRecord::Migration[7.0]
  def change
    rename_column :empresas, :income, :size
    change_column :empresas, :size, :string
  end
end

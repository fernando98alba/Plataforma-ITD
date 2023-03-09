class ChangeColumnTypeAspiration < ActiveRecord::Migration[7.0]
  def change
    change_column :aspiracions, :estratégico, :float
    change_column :aspiracions, :estructural, :float
    change_column :aspiracions, :humano, :float
    change_column :aspiracions, :relacional, :float
    change_column :aspiracions, :natural, :float
    change_column :aspiracions, :estrategia, :float
    change_column :aspiracions, :modelos_de_negocios, :float
    change_column :aspiracions, :governance, :float
    change_column :aspiracions, :procesos, :float
    change_column :aspiracions, :tecnología, :float
    change_column :aspiracions, :datos_y_analítica, :float
    change_column :aspiracions, :modelo_operativo, :float
    change_column :aspiracions, :propiedad_intelectual, :float
    change_column :aspiracions, :personas, :float
    change_column :aspiracions, :ciclo_de_vida_del_colaborador, :float
    change_column :aspiracions, :estructura_organizacional, :float
    change_column :aspiracions, :stakeholders, :float
    change_column :aspiracions, :marca, :float
    change_column :aspiracions, :clientes, :float
    change_column :aspiracions, :sustentabilidad, :float
  end
end

class ChangeHabilitadorName < ActiveRecord::Migration[7.0]
  def change
    rename_column :aspiracions, :estrategico, :estratégico
    rename_column :aspiracions, :modelosdenegocios, :modelos_de_negocios
    rename_column :aspiracions, :datosyanalítica, :datos_y_analítica
    rename_column :aspiracions, :modelooperativo, :modelo_operativo
    rename_column :aspiracions, :propiedadintelectual, :propiedad_intelectual
    rename_column :aspiracions, :ciclodevidadelcolaborador, :ciclo_de_vida_del_colaborador
    rename_column :aspiracions, :estructuraorganizacional, :estructura_organizacional
  end
end

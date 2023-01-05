class AddScoresToAspiracion < ActiveRecord::Migration[7.0]
  def change
    add_column :aspiracions, :estrategico, :integer
    add_column :aspiracions, :estructural, :integer
    add_column :aspiracions, :humano, :integer
    add_column :aspiracions, :relacional, :integer
    add_column :aspiracions, :natural, :integer
    add_column :aspiracions, :estrategia, :integer
    add_column :aspiracions, :modelosdenegocios, :integer
    add_column :aspiracions, :governance, :integer
    add_column :aspiracions, :procesos, :integer
    add_column :aspiracions, :tecnología, :integer
    add_column :aspiracions, :datosyanalítica, :integer
    add_column :aspiracions, :modelooperativo, :integer
    add_column :aspiracions, :propiedadintelectual, :integer
    add_column :aspiracions, :personas, :integer
    add_column :aspiracions, :ciclodevidadelcolaborador, :integer
    add_column :aspiracions, :estructuraorganizacional, :integer
    add_column :aspiracions, :stakeholders, :integer
    add_column :aspiracions, :marca, :integer
    add_column :aspiracions, :clientes, :integer
    add_column :aspiracions, :sustentabilidad, :integer
  end
end

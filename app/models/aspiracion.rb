class Aspiracion < ApplicationRecord
  belongs_to :empresa
  validates_presence_of :maturity_score, :alignment_score, :estratégico, :estructural, :humano, :relacional, :natural, :estrategia, :modelos_de_negocios, :governance, :procesos, :tecnología, :datos_y_analítica, :modelo_operativo, :propiedad_intelectual, :personas, :ciclo_de_vida_del_colaborador, :estructura_organizacional, :stakeholders, :marca, :clientes, :sustentabilidad
end

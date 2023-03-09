class ComVerificador < ApplicationRecord
  OPTIONS = ['', 'No, no contamos con el verificador', 'Si, contamos con el verificador']
  validates_inclusion_of :state, :in => [0,1,2]
  belongs_to :itdind
  belongs_to :verificador
end

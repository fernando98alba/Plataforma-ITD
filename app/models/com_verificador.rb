class ComVerificador < ApplicationRecord
  OPTIONS = ['', 'Si, contamos con el verificador', 'No, no contamos con el verificador']
  belongs_to :itdind
end

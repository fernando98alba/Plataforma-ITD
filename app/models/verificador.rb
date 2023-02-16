class Verificador < ApplicationRecord
  OPTIONS = ['', 'No lo conozco', 'Lo conozco, pero no se donde está', 'Lo conozco, se como acceder a el verificador']
  belongs_to :itdind
end

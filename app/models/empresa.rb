class Empresa < ApplicationRecord
  OPTIONS_KEYS = {micro: 'Menos de 9', small: 'Entre 11 y 49', medium: 'Entre 50 y 249', large: 'Entre 50 y 249' }
  OPTIONS = ['Menos de 9', 'Entre 11 y 49', 'Entre 50 y 249', 'Lo conozco, se como acceder a el verificador']
  validates_inclusion_of :size, :in => OPTIONS
  has_many :users
  has_many :itdcons
  has_many :brechas
  has_many :aspiracion

  validates :name, presence: true
  validates :rut, presence: true
  validates :sector, presence: true
  validates :size, presence: true
end

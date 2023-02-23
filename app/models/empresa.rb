class Empresa < ApplicationRecord
  OPTIONS = {"micro" => 'Menos de 9', "small" => 'Entre 11 y 49', "medium" => 'Entre 50 y 249', "large" => 'Mayor a 250' }
  validates_inclusion_of :size, :in => OPTIONS.keys
  has_many :users
  has_many :itdcons
  has_many :brechas
  has_many :aspiracion

  validates :name, presence: true
  validates :rut, presence: true
  validates :sector, presence: true
  validates :size, presence: true
end

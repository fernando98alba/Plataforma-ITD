class Empresa < ApplicationRecord
  OPTIONS = {"micro" => 'Menos de 9', "small" => 'Entre 11 y 49', "medium" => 'Entre 50 y 249', "large" => 'Mayor a 250' }
  validates_inclusion_of :size, :in => OPTIONS.keys
  has_many :users, dependent: :destroy
  has_many :itdcons, dependent: :nullify
  has_many :brechas, dependent: :destroy
  has_many :areas, dependent: :destroy
  has_one :aspiracion, dependent: :destroy

  validates :name, presence: true
  validates :rut, presence: true
  validates :rut, uniqueness: true
  validates :sector, presence: true
  validates :size, presence: true
end

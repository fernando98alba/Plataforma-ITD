class Empresa < ApplicationRecord
  has_many :users
  has_many :itdcons
  has_many :brechas
  has_one :aspiracion

  validates :name, presence: true
  validates :rut, presence: true
  validates :sector, presence: true
  validates :income, presence: true
end

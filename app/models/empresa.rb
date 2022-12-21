class Empresa < ApplicationRecord
  has_many :users
  has_many :itdcons
  has_many :brechas
  has_one :aspiracion
end

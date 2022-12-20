class Empresa < ApplicationRecord
  has_many :users
  as_many :itdcons
  as_many :brechas
  has_one :aspiracion
end

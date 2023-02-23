class Verificador < ApplicationRecord
  belongs_to :driver
  has_many :com_verificadors
end

class Iniciativa < ApplicationRecord
  belongs_to :madurez
  belongs_to :driver
  has_many :brechas
end

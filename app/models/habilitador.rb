class Habilitador < ApplicationRecord
  belongs_to :dat
  has_many :elementos
end

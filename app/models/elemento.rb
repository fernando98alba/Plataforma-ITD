class Elemento < ApplicationRecord
  belongs_to :habilitador
  has_many :drivers
end

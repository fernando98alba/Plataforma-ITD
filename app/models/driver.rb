class Driver < ApplicationRecord
  belongs_to :elemento
  has_one :pregunta
  has_many :iniciativas
end

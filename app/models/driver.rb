class Driver < ApplicationRecord
  belongs_to :elemento
  has_one :cuestionario
  has_many :iniciativas
end

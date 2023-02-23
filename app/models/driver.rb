class Driver < ApplicationRecord
  belongs_to :elemento
  has_many :iniciativas
  has_many :verificadors
end

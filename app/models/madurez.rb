class Madurez < ApplicationRecord
  has_many :itdcons
  has_many :itdinds
  has_many :iniciativas
end

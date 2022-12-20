class Itdcon < ApplicationRecord
  belongs_to :empresa
  belongs_to :madurez
  belongs_to :alineamiento
  has_many :itdinds
end

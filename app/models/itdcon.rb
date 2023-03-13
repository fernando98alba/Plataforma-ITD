class Itdcon < ApplicationRecord
  belongs_to :empresa
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  has_many :itdinds, dependent: :destroy
  has_many :itdareas, dependent: :destroy

end

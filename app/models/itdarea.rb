class Itdarea < ApplicationRecord
  has_many :itdinds, dependent: :destroy
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  belongs_to :itdcon
  belongs_to :area
end

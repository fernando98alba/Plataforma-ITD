class Itdind < ApplicationRecord
  belongs_to :user
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  belongs_to :itdcon
  has_one :verificador
  accepts_nested_attributes_for :verificador
end

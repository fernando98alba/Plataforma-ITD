class Itdsin < ApplicationRecord
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
end

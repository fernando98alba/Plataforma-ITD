class Itdsin < ApplicationRecord
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  (1..91).each do |identifier|
    validates "p#{identifier}", numericality: {less_than_or_equal_to: 4}
  end
end

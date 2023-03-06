class Itdind < ApplicationRecord
  belongs_to :user
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  belongs_to :itdcon
  has_many :com_verificadors
  (1..91).each do |identifier|
    validates "p#{identifier}", numericality: {less_than_or_equal_to: 4}, allow_nil: true
  end
  accepts_nested_attributes_for :com_verificadors
end

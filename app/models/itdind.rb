class Itdind < ApplicationRecord
  belongs_to :user
  belongs_to :madurez, optional: true
  belongs_to :alineamiento, optional: true
  belongs_to :itdcon
  belongs_to :itdarea
  has_many :com_verificadors, dependent: :delete_all
  (1..91).each do |identifier|
    validates "p#{identifier}", numericality: {less_than_or_equal_to: 4}, allow_nil: true
  end
  accepts_nested_attributes_for :com_verificadors
end

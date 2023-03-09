class Area < ApplicationRecord
  belongs_to :empresa
  has_many :users, dependent: :nullify
  validates :name, presence: true, length: { minimum: 2 }
  validates :name, uniqueness: {scope: :empresa_id}
end

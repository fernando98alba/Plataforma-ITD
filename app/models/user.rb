class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :name, presence: true
  validates :lastname, presence: true
  belongs_to :empresa
  has_many :itdinds
  validate :password_complexity
  accepts_nested_attributes_for :empresa
  private

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, ' no cumple los requisitos de complejidad'
  end

  def block_from_invitation?
    #If the user has not been confirmed yet, we let the usual controls work
    if confirmed_at.blank?
      return invited_to_sign_up?
    else #if the user was confirmed, we let them in (will decide to accept or decline invitation from the dashboard)
      return false
    end
  end
end

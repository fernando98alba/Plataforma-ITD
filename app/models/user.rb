class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  belongs_to :empresa, optional: true
  has_many :itdinds

  private

  def block_from_invitation?
    #If the user has not been confirmed yet, we let the usual controls work
    if confirmed_at.blank?
      return invited_to_sign_up?
    else #if the user was confirmed, we let them in (will decide to accept or decline invitation from the dashboard)
      return false
    end
  end
end

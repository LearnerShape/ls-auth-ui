class Authentication < ApplicationRecord
  belongs_to :credential
  belongs_to :authenticator, class_name: 'Contact'

  scope :is_invited, -> { where(status: 'invited') }
  scope :is_accepted, -> { where(status: 'accepted') }

  def mark_accepted
    update(status: 'accepted')
  end
end

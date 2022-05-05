class Authentication < ApplicationRecord
  belongs_to :credential
  belongs_to :authenticator, class_name: 'Contact'

  scope :is_invited, -> { where(status: 'invited') }
  scope :is_accepted, -> { where(status: 'accepted') }
  scope :is_refused, -> { where(status: 'refused') }

  def mark_accepted
    update(status: 'accepted')
  end

  def mark_refused
    update(status: 'refused')
  end

  def mark_revoked
    update(status: 'revoked')
  end
end

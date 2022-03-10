class Credential < ApplicationRecord
  belongs_to :skill
  belongs_to :holder, class_name: 'Contact'
  has_many :authentications

  scope :is_draft, -> { where(status: 'draft') }
  scope :is_authenticated, -> { where(status: 'authenticated') }

  def mark_authenticated
    update(status: 'authenticated')
  end
end

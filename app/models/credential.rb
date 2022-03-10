class Credential < ApplicationRecord
  belongs_to :skill
  belongs_to :holder, class_name: 'Contact'
  has_many :authentications

  def mark_authenticated
    update(status: 'authenticated')
  end
end

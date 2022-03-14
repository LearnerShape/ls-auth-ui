class PublicView < ApplicationRecord
  belongs_to :owner, class_name: "Contact"

  before_create :set_uuid

  scope :is_active, -> { where(status: 'active') }
  scope :is_inactive, -> { where(status: 'inactive') }

  def credential_skill_names_for_index
    credentials.map do |id|
      Credential.where(id: id).is_authenticated.map(&:skill).map(&:name)[0]
    end.compact
  end

  def credentials_for_display
    credentials.map do |id|
      Credential.where(id: id).is_authenticated.first
    end.compact
  end

  def active?
    status == 'active'
  end

  def mark_inactive
    update(status: 'inactive')
  end

  def mark_active
    update(status: 'active')
  end
  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end

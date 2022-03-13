class PublicView < ApplicationRecord
  belongs_to :owner, class_name: "Contact"

  before_create :set_uuid

  scope :is_active, -> { where(status: 'active') }

  def credential_skill_names_for_index
    Credential.where(id: credentials).is_authenticated.map(&:skill).map(&:name)
  end

  def credentials_for_display
    Credential.where(id: credentials).is_authenticated
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end

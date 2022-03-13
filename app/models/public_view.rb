class PublicView < ApplicationRecord
  belongs_to :owner, class_name: "Contact"

  before_create :set_uuid

  def credential_skill_names_for_index
    Credential.where(id: credentials).map(&:skill).map(&:name)
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end

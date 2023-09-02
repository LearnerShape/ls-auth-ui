class Skill < ApplicationRecord
  has_many :credentials
  belongs_to :logo, optional: true

  def can_add_logo?
    third_party? || !external_authentications?
  end

  def has_image?
    logo.try(:image).try(:attached?)
  end

  def image
    logo.try(:image)
  end

  def program
    Program.where(skill: self).first
  end

  def credential
    credentials.first
  end

  private

  def third_party?
    Program.where(skill_id: id).count.positive?
  end

  def external_authentications?
    credentials.map do |c|
      c.authentications.where.not(authenticator_id: c.holder_id).count
    end.flatten.sum.positive?
  end
end

class Skill < ApplicationRecord
  has_many :credentials
  belongs_to :logo, optional: true
end

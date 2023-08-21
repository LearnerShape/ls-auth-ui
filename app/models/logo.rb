class Logo < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :skills
end

class Logo < ApplicationRecord
  has_one_attached :image
  belongs_to :creator, class_name: "User"
  has_many :skills
end

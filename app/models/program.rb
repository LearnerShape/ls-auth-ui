class Program < ApplicationRecord
  belongs_to :skill
  belongs_to :creator, class_name: 'Contact'
  has_many :credentials, through: :skill
end

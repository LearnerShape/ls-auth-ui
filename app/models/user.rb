class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :contact

  def self.create_with_contact(args)
    user = self.create(args)
    user.create_or_join_contact
    user
  end

  def create_or_join_contact
    contact = Contact.retrieve_or_build(name: name, email: email)
    if contact
      contact.update(user_id: self.id)
    end
  end
end

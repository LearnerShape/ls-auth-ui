class Contact < ApplicationRecord
  belongs_to :user, optional: true

  def self.retrieve_or_build(name:, email:)
    contact = Contact.where(email: email).first
    return contact if contact

    contact = Contact.create(name: name, email: email)
    api_user = ::Commands::CreateUser.do(name: name, email: email)
    Rails.logger.info("CreateUser: response from api: #{api_user}")
    api_id = api_user.fetch('id', nil)
    if api_id
      contact.update(api_id: api_id)
    end
    contact
  end
end

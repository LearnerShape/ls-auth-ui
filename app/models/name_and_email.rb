class NameAndEmail
  attr_reader :name, :email

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def self.parse(row)
    matches = /\A(.*) <(.*)>\z/.match(row)
    new(name: matches[1], email: matches[2])
  end
end

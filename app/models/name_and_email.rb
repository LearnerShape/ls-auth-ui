class NameAndEmail
  attr_reader :name, :email

  EXPECTED_PATTERN = /\A(.*) <(.*)>\z/

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def self.retrieve_or_build_contacts(params)
    lines = split(params)
    names_and_emails = lines.map { |line| parse(line) }
    names_and_emails.map do |name_and_email|
      Contact.retrieve_or_build(name: name_and_email.name, email: name_and_email.email)
    end
  end

  def self.split(params)
    params.split(/\n+|\r+/).reject(&:empty?)
  end

  def self.parse(line)
    matches = EXPECTED_PATTERN.match(line)
    new(name: matches[1], email: matches[2])
  end

  def self.invalid?(blob)
    return false if blob.empty?

    lines = split(blob)
    lines.any? { |l| EXPECTED_PATTERN !~ l }
  end
end

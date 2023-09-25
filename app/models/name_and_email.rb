class NameAndEmail
  attr_reader :name, :email

  EXPECTED_PATTERN = /\A(.*) <(.*)>\z/

  def initialize(name:, email:)
    @name = name
    @email = email
  end

  def self.parse(row)
    matches = EXPECTED_PATTERN.match(row)
    new(name: matches[1], email: matches[2])
  end

  def self.invalid?(blob)
    return false if blob.empty?

    lines = blob.split("\n").reject(&:empty?)
    lines.any? { |l| EXPECTED_PATTERN !~ l }
  end
end

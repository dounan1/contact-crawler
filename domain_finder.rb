class DomainFinder
  class << self

    def find_domain(email)
      return if email.nil?

      email.gsub(/.+(@|at)([^.]+.+)/, '\2')
    end

    def find_domains(emails)
      return [] if emails.empty?

      domains = []

      emails.each do |email|
        domains << find_domain(email)
      end

      domains
    end
  end
end
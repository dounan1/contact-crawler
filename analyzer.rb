require_relative 'email_finder'
require_relative 'form_finder'
require_relative 'result'

class Analyzer
  class << self

    def find_contacts(page, email_patterns, site, username)

      emails = EmailFinder.find_emails(page, email_patterns)
      form = FormFinder.find_forms(page)

      p 'email found at : ' + emails.join('|') unless emails.empty?
      p 'form found at: ' + form unless form.nil?

      Result.store(site, username, page, emails, form)
    end
  end
end

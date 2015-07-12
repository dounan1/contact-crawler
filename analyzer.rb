require './domain_finder'
require './email_finder'
require './form_finder'

class Analyzer
  class << self

    def find_contacts(page)

      return if page.nil?

      results = {url: page.url.host.to_s, emails: [], domains: [], forms: []}

      emails = EmailFinder.find_emails(page)
      forms = FormFinder.find_forms(page)

      p 'email found at : ' + emails.join('|') unless emails.empty?
      p 'form found at: ' + forms unless forms.nil?

      results[:emails] << emails unless emails.empty?
      results[:forms] << forms unless forms.nil?

      # emails.each { |email| results << { url: page.url, email: email, form: nil}; p email } unless emails.nil?
      # forms.each { |form| results << { url: page.url, email: nil, form: form }; p form } unless forms.nil?

      results
    end
  end
end

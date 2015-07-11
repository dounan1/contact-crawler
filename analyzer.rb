require './domain_finder'
require './email_finder'
require './form_finder'
require './csv_writer'

class Analyzer
  class << self

    def find_contacts(page, results)

      return if page.nil?

      emails = EmailFinder.find_emails(page)
      forms = FormFinder.find_forms(page)

      p 'email found at : ' + emails.join('|') unless emails.empty?
      p 'form found at: ' + forms unless forms.nil?

      results[:emails] << emails unless emails.empty?
      results[:forms] << forms unless forms.nil?

      # emails.each { |email| results << { url: page.url, email: email, form: nil}; p email } unless emails.nil?
      # forms.each { |form| results << { url: page.url, email: nil, form: form }; p form } unless forms.nil?

      CsvWriter.write(rows_from(results))

    end


    def rows_from(results)
      emails = results[:emails].compact.uniq.flatten
      forms = results[:forms].compact.uniq.flatten

      rows = []

      emails.each do |email|
        rows << [ results[:url] , email, DomainFinder.find_domain(email), nil ]
      end

      forms.each do |form|
        rows << [ results[:url] , nil, nil, form ]
      end

      rows
    end
  end
end

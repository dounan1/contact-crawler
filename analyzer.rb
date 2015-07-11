require 'csv'

class Analyzer
  class << self

    def find_contacts(page, results)

      return if page.nil?

      emails = find_emails(page)
      forms = find_forms(page)

      p 'email found at : ' + emails.join('|') unless emails.empty?
      p 'form found at: ' + forms unless forms.nil?

      results[:emails] << emails unless emails.empty?
      results[:forms] << forms unless forms.nil?

      # emails.each { |email| results << { url: page.url, email: email, form: nil}; p email } unless emails.nil?
      # forms.each { |form| results << { url: page.url, email: nil, form: form }; p form } unless forms.nil?

      write(results)

    end

    def find_emails(page)
      return [] if page.body.nil?
      find_all_emails(page)
    end

    def find_all_emails(page)

      regular_emails = page.body.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i).to_a
      at_and_dotted_emails = page.body.match(/[a-zA-Z0-9\._\-]{3,}(@|AT|\s(at|AT)\s|\s*[\[\(\{]\s*(at|AT)\s*[\]\}\)]\s*)[a-zA-Z]{3,}(\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s^*)[a-zA-Z]{2,}((\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s*)[a-zA-Z]{2,})?$/).to_a

      results  = [] << regular_emails[0] << at_and_dotted_emails[0]
      results.compact
    end

    def find_whitelisted_emails(page)
      reg = /[A-Z0-9._%+-]+@gmail.com/i
      page.body.scan(reg).uniq
    end

    def find_domains(emails)
      return [] if emails.empty?

      domains = []

      emails.each do |email|
        domains << find_domain(email)
      end

      domains
    end

    def find_domain(email)
      return if email.nil?

      email.gsub(/.+(@|at)([^.]+.+)/, '\2')
    end

    def find_forms(page)
      # has a form with email field and a message body

      return if page.doc.nil?

      contact_form_found = false;

      #search for contact form
      forms = page.doc.search('form')

      if forms.any?
        forms.each do |form|
          if contact_form_search(form)
            contact_form_found = true
            break
          end
        end
      end

      contact_form_found ? page.url.to_s : nil
    end

    def contact_form_search(form)
      # p form.content
      email_field_found = !form.content.match(/email/i).nil?
      subject_field_found = !form.content.match(/subject/i).nil?
      comment_field_found = !form.content.match(/comment/i).nil?
      message_field_found = !form.content.match(/message/i).nil?

      # p 'email form found: ' + email_field_found.to_s
      # p 'subject form found: ' + subject_field_found.to_s
      # p 'comment form found: ' + comment_field_found.to_s
      # p 'message form found: ' + message_field_found.to_s

      email_field_found && (subject_field_found || comment_field_found || message_field_found)
    end

    def write(results)

      CSV.open('results.csv', 'ab') do |csv|
        rows_from(results).each do |row| # write results
          csv << row
        end
      end
    end

    def rows_from(results)
      emails = results[:emails].compact.uniq.flatten
      forms = results[:forms].compact.uniq.flatten

      rows = []

      emails.each do |email|
        rows << [ results[:url] , email, find_domain(email), nil ]
      end

      forms.each do |form|
        rows << [ results[:url] , nil, nil, form ]
      end

      rows
    end

  end
end
#!/usr/bin/env ruby
require 'anemone'
require 'csv'

class Crawler

  def self.crawl(url)
    urls = CSV.read('urls.csv', "r:ISO-8859-1")
    url ||= 'http://www.example.com'


    results = {url:url, emails:[], domains:[], forms:[]}

    Anemone.crawl(url) do |anemone|
      anemone.focus_crawl { |page| links_without_queries_on page   }

      anemone.on_every_page do |page|
        p page.url.to_s
        find_contacts(page, results)
      end

      anemone.after_crawl do
        # write(results)
      end
    end
  end

  def self.find_contacts(page, results)

    return if page.nil?

    emails = find_emails(page)
    domains = find_domains(emails)
    forms = find_forms(page)

    p 'email found at : ' + emails.join('|') unless emails.empty?
    p 'domain found at : ' + domains.join('|') unless domains.empty?
    p 'form found at: ' + forms unless forms.nil?

    results[:emails] << emails unless emails.empty?
    results[:domains] << domains unless domains.empty?
    results[:forms] << forms unless forms.nil?

    # emails.each { |email| results << { url: page.url, email: email, form: nil}; p email } unless emails.nil?
    # forms.each { |form| results << { url: page.url, email: nil, form: form }; p form } unless forms.nil?
  end

  def self.links_without_queries_on(page)
    page.links.select { |link| link.query.nil? }
  end

  def self.find_emails(page)
    return if page.body.nil?
    page.body.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i).to_a
  end

  def self.find_domains(emails)
    return [] if emails.empty?

    domains = []

    emails.each do |email|
     domains << email.gsub(/.+@([^.]+).+/, '\1')
    end

    domains
  end

  def self.find_forms(page)
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

    # return page.url if contact_form_found

    # email_input_exists = false;
    # message_subject_exists = false;
    # name_contact_exists = false;
    #
    # inputs = page.doc.search('form input')
    # if inputs.any?
    #   inputs.each do |form|
    #     p form
    #     #search for contact fields
    #   end
    # end

    contact_form_found ? page.url.to_s : nil
  end

  def self.contact_form_search(form)
    # p form.content
    email_field_found = !form.content.match(/email/i).nil?
    subject_field_found = !form.content.match(/subject/i).nil?
    # p 'email form found: ' + email_field_found.to_s
    # p 'subject form found: ' + subject_field_found.to_s
    email_field_found && subject_field_found
  end

  def self.write(results)

    CSV.open('results.csv', 'w') do |csv|

      csv << ['Url', 'Email', 'Domain', 'Contact'] # write header

      rows_from(results).each do |row| # write results
        csv << row
      end
    end
  end

  def self.rows_from(results)
  end
end

Crawler.crawl ARGV[0]
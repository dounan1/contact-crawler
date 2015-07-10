#!/usr/bin/env ruby
require 'anemone'
require 'csv'

class Crawler

  def self.crawl(url)
    urls = CSV.read('urls.csv', "r:ISO-8859-1")
    url ||= 'http://www.example.com'
    results = [] # array of {url: url, email: email, form: form}

    Anemone.crawl(url) do |anemone|
      anemone.focus_crawl { |page| links_without_queries_on page   }

      anemone.on_every_page do |page|
        p page.url
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
    forms = find_forms(page)

    p emails
    p forms

    # emails.each { |email| results << { url: page.url, email: email, form: nil}; p email } unless emails.nil?
    # forms.each { |form| results << { url: page.url, email: nil, form: form }; p form } unless forms.nil?
  end

  def self.links_without_queries_on(page)
    page.links.select { |link| link.query.nil? }
  end

  def self.find_emails(page)
    return if page.body.nil?
    page.body.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)
  end

  def self.find_forms(page)
    # has a form with email field and a message body

    return if page.doc.nil?

    forms = page.doc.search('form input')
    if forms.any?
      forms.each do |form|
        p form
        #search for contact fields
      end
    end
    forms
  end

  def self.write(results)
    CSV.open('results.csv', 'w') do |csv|
      csv << ['Url', 'Email', 'Domain', 'Contact']
      results.each do |row|
        csv << row
      end
    end
  end
end

Crawler.crawl ARGV[0]
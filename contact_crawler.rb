require 'anemone'
require './csv_writer'
require './analyzer'


class ContactCrawler
  PATH_BLACKLIST = ['.jpg', '.pdf', 'gif'] # want contact.php or .asp, but not any unparsable files
  HOST_BLACKLIST = [] # e.g. third party hosts like instagram, youtube...


  class << self

    def crawl(urls, email_patterns, limit)

      results = []

      Anemone.crawl(urls, skip_query_strings: true, ) do |anemone|

        anemone.focus_crawl { |page| permitted_urls(page, limit) }

        anemone.on_every_page do |page|
          p page.url.to_s

          # p 'body: ' + page.body.to_s
          # p 'links: ' + page.links.to_s
          # p 'doc: ' + page.doc.content.to_s
          #
          # p 'doc nil? ' + page.doc.nil?.to_s
          # p 'body nil? ' + page.body.nil?.to_s

          results << Analyzer.find_contacts(page, email_patterns)
        end

        anemone.after_crawl do
          CsvWriter.no_results([urls].flatten) if is_empty(results)

          results.each do |result|
            CsvWriter.write(rows_from(result))
          end
        end
      end
    end

    def is_empty(results)
      results.map{ |r| r[:emails][0] }.compact.empty? && results.map{ |r| r[:forms][0] }.compact.empty?
    end

    def rows_from(results)
      emails = results[:emails].compact.uniq.flatten
      forms = results[:forms].compact.uniq.flatten

      rows = []

      emails.each do |email|
        rows << [ results[:url] , email, results[:subpages], nil ]
      end

      forms.each do |form|
        rows << [ results[:url] , nil, results[:subpages], form ]
      end

      rows
    end

    def permitted_urls(page, limit)
      page.links.slice(0..limit).select { |link| targeted(link) }
    end

    def targeted(link)
      !on_blacklisted_hosts(link.host) &&
        !on_blacklisted_paths(link.path) &&
          limit_to_contact_pages(link)
    end

    def on_blacklisted_paths(path)
      PATH_BLACKLIST.inject(false) {|r, blacklisted| r || path.include?(blacklisted) }
    end

    def on_blacklisted_hosts(host)
      HOST_BLACKLIST.inject(false) {|r, blacklisted| r || host.include?(blacklisted) }
    end

    def limit_to_contact_pages(link)
      link.path.downcase =~ /(contact|about|connect)/
    end
  end
end
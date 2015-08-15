require 'anemone'
require_relative 'csv_writer'
require_relative 'analyzer'


class ContactCrawler
  PATH_BLACKLIST = ['.jpg', '.pdf', '.gif', '.png'] # want contact.php or .asp, but not any unparsable files
  HOST_BLACKLIST = [] # e.g. third party hosts like instagram, youtube...
  DEBUG = false

  class << self

    def crawl(site, urls, email_patterns, limit, username)

      Anemone.crawl(urls, discard_page_bodies: true, depth_limit: 4, skip_query_strings: true, ) do |anemone|

        anemone.focus_crawl { |page| permitted_urls(page, limit) }

        anemone.on_every_page do |page|
          log(page)
          Analyzer.find_contacts(page, email_patterns, site, username)
        end
      end
    end

    def log(page)
      DEBUG ? debug(page) : (p page.url.to_s)
    end

    def debug(page)
      p 'body: ' + page.body.to_s
      p 'links: ' + page.links.to_s
      p 'doc: ' + page.doc.content.to_s

      p 'doc nil? ' + page.doc.nil?.to_s
      p 'body nil? ' + page.body.nil?.to_s
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
class ContactCrawler
  class << self

    def crawl(urls, limit)

      Anemone.crawl(urls) do |anemone|
        anemone.focus_crawl { |page| permitted_urls(page, limit) }

        anemone.on_every_page do |page|
          results = {url: page.url.host.to_s, emails: [], domains: [], forms: []}
          p page.url.to_s

          # p 'body: ' + page.body.to_s
          # p 'links: ' + page.links.to_s
          # p 'doc: ' + page.doc.content.to_s
          #
          # p 'doc nil? ' + page.doc.nil?.to_s
          # p 'body nil? ' + page.body.nil?.to_s
          Analyzer.find_contacts(page, results)
        end

        anemone.after_crawl do
        end
      end
    end

    def permitted_urls(page, limit)
      page.links.slice(0..limit).select { |link| targeted(link) }
    end

    def targeted(link)
      blacklist = ['www.youtube.com', 'youtube.com'] # reject megasites for now
      path_blacklist = '.com' # reject recursively linked sites embedded in paths

      #TODO: avoid recursion - make sure no part of the path repeats:
      # eg. /red-line-custom-pages/index.php/red-line-custom-pages/index.php/
      # this can then replace the path_blacklist

      link.query.nil? &&
          !blacklist.include?(link.host) &&
          !link.path.include?(path_blacklist) &&
          limit_to_contact_pages(link)
    end

    def limit_to_contact_pages(link)
      path = link.path.downcase
      path.include?('contact') || path.include?('about') || path.include?('info')
    end
  end
end
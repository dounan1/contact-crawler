class EmailFinder
  @@patterns = ['[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}']

  class << self

    def find_emails(page, email_patterns)
      return [] if page.body.nil?
      @@patterns = email_patterns unless email_patterns.nil?

      find_all_emails(page)
    end

    def find_all_emails(page)

      body = page.body.scrub

      results = []

      @@patterns.each do |pattern|
        # results += body.match(/#{pattern}/i).to_a
        results += body.match(/[a-zA-Z0-9\._\-]{3,}(@|AT|\s(at|AT)\s|\s*[\[\(\{]\s*(at|AT)\s*[\]\}\)]\s*)[a-zA-Z]{3,}(\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s^*)[a-zA-Z]{2,}((\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s*)[a-zA-Z]{2,})?$/).to_a
      end


      # results  = [] << regular_emails[0] << at_and_dotted_emails[0]
      results.compact
    end

    def find_whitelisted_emails(page)
      reg = /[A-Z0-9._%+-]+@gmail.com/i
      page.body.scan(reg).uniq
    end
  end
end
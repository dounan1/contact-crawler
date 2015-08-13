class EmailFinder
  DOTTED_EMAILS = ['[a-zA-Z0-9\._\-]{3,}(@|AT|\s(at|AT)\s|\s*[\[\(\{]\s*(at|AT)\s*[\]\}\)]\s*)[a-zA-Z]{3,}(\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s^*)[a-zA-Z]{2,}((\.|DOT|\s(dot|DOT)\s|\s*[\[\(\{]\s*(dot|DOT)\s*[\]\}\)]\s*)[a-zA-Z]{2,})?$']
  REGULAR_EMAILS = ['[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}']

  @@patterns = REGULAR_EMAILS

  class << self

    def find_emails(page, email_patterns)
      return [] if page.body.nil?
      @@patterns = email_patterns unless email_patterns.nil?

      find_all_emails(page)
    end

    def find_all_emails(page)

      # @@patterns = DOTTED_EMAILS

      body = page.body.scrub

      results = []

      @@patterns.each do |pattern|
        matches = body.match(/#{pattern}/i).to_a
        results << matches[0]
      end

      results.compact
    end

    def find_whitelisted_emails(page)
      reg = /[A-Z0-9._%+-]+@gmail.com/i
      page.body.scan(reg).uniq
    end
  end
end
class EmailFinder
  DOTTED_EMAILS = ['[A-Z0-9._%+-]{3,}(@|\s@\s|AT|\sAT\s|(\s*)?[\<\[\(\{]\s*(@|AT)\s*[\]\}\)\>](\s*)?)[A-Z]{3,}(\.|DOT|\sDOT\s|(\s*)?[\<\[\(\{]\s*(\.|DOT)\s*[\]\}\)\>](\s*)?)[A-Z]{2,}((\.|DOT|\sDOT\s|(\s*)?[\<\[\(\{]\s*(\.|DOT)\s*[\]\}\)\>](\s*)?)[A-Z]{2,4})?$']
  REGULAR_EMAILS = ['[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}']
  @@patterns = DOTTED_EMAILS + REGULAR_EMAILS

  class << self

    def find_emails(page, email_patterns)
      return [] if page.body.nil?
      @@patterns = email_patterns unless email_patterns.nil?

      find_all_emails(page)
    end

    def find_all_emails(page)

      body = page.body.scrub #remove illegal or unparsable characters

      results = []

      @@patterns.each do |pattern|
        matches = body.match(/#{pattern}/i).to_a
        results << matches[0]
      end

      results.uniq.compact
    end

    def find_whitelisted_emails(page)
      reg = /[A-Z0-9._%+-]+@gmail.com/i
      page.body.scan(reg).uniq
    end
  end
end
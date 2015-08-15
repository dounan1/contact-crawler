class Result
  attr_accessor :writer

  def self.result
    @result ||= Result.new
  end

  def self.store(site, username, page, emails, form)
    page_url = page.url.to_s

    emails.each do |email|
      result.writer.write([[ username, site , email, page_url, nil ]])
    end

    result.writer.write([[ username, site , nil, page_url, form ]]) unless form.nil?
  end

  def initialize
    @writer = CsvWriter
  end
end

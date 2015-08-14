class Result
  @@writer = CsvWriter

  class << self

    def store(site, username, page, emails, form)
      page_url = page.url.to_s

      emails.each do |email|
        @@writer.write([[ username, site , email, page_url, nil ]])
      end

      @@writer.write([[ username, site , nil, page_url, form ]]) unless form.nil?
    end

    def writer
      @@writer
    end

  end
end

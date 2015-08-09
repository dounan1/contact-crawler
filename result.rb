class Result
  class << self

    def store(site, username, page, emails, form)
      page_url = page.url.to_s

      emails.each do |email|
        CsvWriter.write([[ username, site , email, page_url, nil ]])
      end

      CsvWriter.write([[ username, site , nil, page_url, form ]]) unless form.nil?
    end

  end
end

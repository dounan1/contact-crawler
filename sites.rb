require 'csv'
require './url_cleaner'

class Sites
  class << self
    def parse(input)
      if input.include?('csv')
        csv = CSV.read(input, "r:ISO-8859-1")
        return csv.map{ |row| { site: row[1], url: UrlCleaner.friendly(row[1]), username: row[0] } }
      else
        return [{ url: [input], username: [''] }]
      end
    end
  end
end
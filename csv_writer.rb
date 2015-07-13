require 'csv'

class CsvWriter
  class << self

    RESULT_FILE = 'results.csv'
    NO_RESULTS = 'no_results.csv'

    def header
      CSV.open(RESULT_FILE, 'w') do |csv|
        csv << ['Website Url', 'e-mail', 'e-mail url', 'contact page URL'] # write header
      end
    end

    def write(results)
      CSV.open(RESULT_FILE, 'ab') do |csv|
        results.each do |row| # write results
          csv << row
        end
      end
    end

    def no_results(sites)
      CSV.open(NO_RESULTS, 'ab') do |csv|
        sites.each do |row| # write results
          csv << [row]
        end
      end
    end
  end
end

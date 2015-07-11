require 'csv'

class CsvWriter
  class << self

    OUTPUT_FILE = 'results.csv'

    def header
      CSV.open(OUTPUT_FILE, 'w') do |csv|
        csv << ['Url', 'Email', 'Domain', 'Contact'] # write header
      end
    end

    def write(results)
      CSV.open(OUTPUT_FILE, 'ab') do |csv|
        results.each do |row| # write results
          csv << row
        end
      end
    end
  end
end
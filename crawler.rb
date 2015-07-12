#!/usr/bin/env ruby
require 'anemone'
require './csv_writer'
require './analyzer'
require './contact_crawler'
require './url_cleaner'

class Crawler
  class << self

    def crawl(sites, whitelist, limit)

      CsvWriter.header

      urls(sites).each do |url|
        ContactCrawler.crawl(url, whitelist, link_limit(limit))
      end
    end

    def link_limit(limit)
      limit ||= '20'
      p 'limit: ' + limit
      limit.to_i
    end

    def urls(arg)
      if arg.nil?
        return ['http://www.example.com']
      end

      if arg.include?('csv')
        csv = CSV.read(arg, "r:ISO-8859-1")
        return csv.map{ |row| UrlCleaner.friendly(row[1]) }.flatten
      else
        return [arg]
      end
    end
  end
end

if ARGV.empty?
  puts %/
usage: crawler <inputfile> [email-whitelist] [link-limit]

  inputfile: list of urls to crawl in csv file
  link-limit: maximum number of links crawled per site
  email-filter: csv file with list of emails format to search eg. *.gmail.com, info@*.com
  /
else
  if !ARGV[1].nil?

    if !ARGV[1].include?('.csv')
      # 2nd Argument is actually the limit
      if ARGV[1].to_i.to_s == ARGV[1]
        Crawler.crawl ARGV[0], nil, ARGV[1]
        exit
      else
        puts 'error: must have csv file as email whitelist'
        exit
      end
    end
  end

  if !ARGV[2].nil? && ARGV[2].to_i.to_s != ARGV[2]
    puts 'error: limit must be a number'
    exit
  end

  Crawler.crawl ARGV[0], ARGV[1], ARGV[2]
end




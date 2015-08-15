#!/usr/bin/env ruby
require 'csv'
require_relative 'contact_crawler'
require_relative 'sites'

class Crawler
  class << self

    def crawl(input, whitelist, limit)

      CsvWriter.header

      Sites.parse(input).each do |site|
        ContactCrawler.crawl(site[:site], site[:url], emails(whitelist), link_limit(limit), site[:username])
      end
    end

    def link_limit(limit)
      limit ||= '20'
      limit.to_i
    end


    def emails(whitelist)
      if !whitelist.nil?
        list = CSV.read(whitelist, "r:ISO-8859-1").flatten.compact
        list.map{ |pattern| pattern.gsub("*",'[A-Z0-9._%+-]+') }
      end
    end
  end
end

if ARGV.empty?
  puts %/
usage: crawler <inputfile> [email-whitelist] [link-limit]

  inputfile: list of urls to crawl in csv file
  email-filter (optional): csv file with list of emails format to search eg. *.gmail.com, info@*.com
  link-limit (optional): maximum number of links crawled per site

output: results.csv
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




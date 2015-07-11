#!/usr/bin/env ruby
require 'anemone'
require './csv_writer'
require './analyzer'
require './contact_crawler'

class Crawler
  class << self

    def crawl(input, limit)

      CsvWriter.header

      urls(input).each do |url|
        ContactCrawler.crawl(friendly(url), link_limit(limit))
      end
    end

    def friendly(url)

      lowercase_url = url.downcase

      [ lowercase_url, new_url(lowercase_url) ]
    end

    def new_url(lowercase_url)
      lowercase_url =~ /www\./ ? lowercase_url.gsub(/www\./,'') : lowercase_url.gsub(/(https?:\/\/)/i, "http://www.")
    end

    def link_limit(limit)
      limit ||= '20'
      limit.to_i
    end

    def urls(arg)
      return ['http://www.example.com'] if arg.nil?

      if arg.include?('csv')
        csv = CSV.read(arg, "r:ISO-8859-1")
        return csv.map{|row| row[1]}
      else
        return [arg]
      end
    end
  end
end

Crawler.crawl ARGV[0], ARGV[1]
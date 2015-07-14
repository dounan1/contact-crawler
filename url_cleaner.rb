#!/usr/bin/env ruby

class UrlCleaner
  class << self

    # makes the domain named into what typically is redirected to - lowercased, with and without www
    def friendly(url)

      lowercase_url = url.downcase

      [ lowercase_url, new_url(lowercase_url) ]
    end

    def new_url(lowercase_url)
      lowercase_url =~ /www\./ ? lowercase_url.gsub(/www\./,'') : lowercase_url.gsub(/(https?:\/\/)/i, "http://www.")
    end
  end
end
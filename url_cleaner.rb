#!/usr/bin/env ruby

class UrlCleaner
  class << self
    def friendly(url)

      lowercase_url = url.downcase

      [ lowercase_url, new_url(lowercase_url) ]
    end

    def new_url(lowercase_url)
      lowercase_url =~ /www\./ ? lowercase_url.gsub(/www\./,'') : lowercase_url.gsub(/(https?:\/\/)/i, "http://www.")
    end
  end
end
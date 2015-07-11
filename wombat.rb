require 'wombat'

Wombat.crawl do
  base_url "http://www.brianleport.com/contact-me/"

  headline xpath: "//h2"
  subheading css: "p.subheading"

  what_is({ css: ".one-half h3" }, :list)
  
  email xpath: '//body' do |e|
    e.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)
  end

  form css: 'form' do |form|
    (!form.match(/email/i).nil? && !form.match(/subject/i).nil?).to_s
  end

  links do
    explore xpath: '//*' do |e|
      e.match(/contact/i)[0]
    end

    features css: '.features'
    enterprise css: '.enterprise'
    blog css: '.blog'
  end
end
require 'wombat'

Wombat.crawl do
  base_url "http://www.brianleport.com/"
  path "/contact-me/"

  headline xpath: "//h1"
  subheading css: "p.subheading"

  what_is({ css: ".one-half h3" }, :list)
  
  email css: 'p'

  links do
    explore xpath: '//*[@class="wrapper"]' 

    features css: '.features'
    enterprise css: '.enterprise'
    blog css: '.blog'
  end
end
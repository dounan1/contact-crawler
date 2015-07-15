# contact-crawler
usage: crawler <inputfile> [email-whitelist] [link-limit]

  inputfile: list of urls to crawl in csv file
  email-filter (optional): csv file with list of emails format to search eg. *.gmail.com, info@*.com
  link-limit (optional): maximum number of links crawled per site

outputs: results.csv - list of sites with contacts found
         no_results.csv - list of sites without contacts found

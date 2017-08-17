#Note that when using gemfiles the require command must have the same name as specified in the gemfile ie. all lowercase for this project
require 'nokogiri'
require 'httparty'
require 'json'
#require 'pry'
require 'csv'

class Scrapper
  def scrape
    page = HTTParty.get('https://www.sec.gov/Archives/edgar/data/4962/0000004962-04-000203.txt')
    parse_page = Nokogiri::HTML(page)

    return parse_page.css('table')[1].to_s.match(/Total\s*[0-9\,]*/)[0].gsub(/\s+/,' ')
  end
end

value = Scrapper.new.scrape

#Pry.start(binding)

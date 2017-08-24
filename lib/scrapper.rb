#Note that when using gemfiles the require command must have the same name as specified in the gemfile ie. all lowercase for this project
require 'nokogiri'
require 'httparty'
require 'json'
require 'pry'
require 'csv'

class Scrapper
  attr_accessor :year,:quarter,:company
  def initialize(year,quarter,company)
    @year = year
    @quarter = quarter
    @company = company
  end
  def scrape
    company_url = ""
    page = HTTParty.get("https://www.sec.gov/Archives/edgar/full-index/"+year+"/QTR"+quarter+"/form.idx")
    parse_page = Nokogiri::HTML(page).to_s.split(/\n/)
    parse_page.each do |x|
      #need to change this to a regex of company nam
      if x.match(/THQ\sINC/) != nil and x.match(/10-Q/) != nil
        company_url = x
      end
    end
    
    if company_url == ""
      raise "Company 10-Q cannot be found"
    end

    search_url = company_url.match(/edgar\/[a-z\/0-9\-\.]*/).to_s

    page = HTTParty.get('https://www.sec.gov/Archives/' + search_url)

    parse_page = Nokogiri::HTML(page)

    thingy = parse_page.to_s.split(/\n/)

    holding_thingy_array = []
    grabbed = false

    thingy.each_with_index do |x,i|
      if x.match(/TOTAL ASSETS/) != nil
        thingy[i,thingy.length].each do |y|
          if y.match(/<\/tr>/) == nil
            holding_thingy_array << y
          else 
            grabbed = true
            break
          end
          if grabbed == true
            break
          end
        end
      end
    end

    our_value = holding_thingy_array[18].match(/[0-9\,]*<\/font>/).to_s.split('<')[0]

    our_value = "TotalAssets " + our_value
    
    return our_value
  end
end

s = Scrapper.new(year="2004",quarter="3",company="THQ INC").scrape

#Pry.start(binding)

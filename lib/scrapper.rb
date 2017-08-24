#Note that when using gemfiles the require command must have the same name as specified in the gemfile ie. all lowercase for this project
require 'nokogiri'
require 'httparty'
require 'json'
require 'pry'
require 'csv'

class Scrapper
  def scrape
    page = HTTParty.get('https://www.sec.gov/Archives/edgar/data/4962/0000004962-04-000203.txt')
    parse_page = Nokogiri::HTML(page)

    return parse_page.css('table')[1].to_s.match(/Total\s*[0-9\,]*/)[0].gsub(/\s+/,' ')
  end
end

#value = Scrapper.new.scrape

#hypothetical search parameters
year = "2004"
quarter = "QTR3"
company = "THQ INC"

#get request on list of forms with year and quarter
page = HTTParty.get("https://www.sec.gov/Archives/edgar/full-index/"+year+"/"+quarter+"/form.idx")

regex_start = "10-Q\s+"
regex_end = "\s+[0-9]*\s+[0-9\-]*\s+[a-z\/0-9\-\.]*"
full_regex = regex_start + company + regex_end 
company_url = ""

#creating array with each line as element and searching for company name
parse_page = Nokogiri::HTML(page).to_s.split(/\n/)
parse_page.each do |x|
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

our_value = "Total Assets " + our_value
Pry.start(binding)

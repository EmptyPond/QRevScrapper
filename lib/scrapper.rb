#Note that when using gemfiles the require command must have the same name as specified in the gemfile ie. all lowercase for this project
require 'nokogiri'
require 'httparty'
require 'json'
#require 'pry'
require 'csv'

class Scrapper
  attr_accessor :year,:quarter,:company
  def initialize(year,quarter,company)
    @year = year
    @quarter = quarter
    @company = company
  end

  def url_response_split(url)
    page = HTTParty.get(url)
    parse_page = Nokogiri::HTML(page).to_s.split(/\n/)
  end

  def company_url_getter(parse_page)
    company_url = ""

    begin
    parse_page.each do |x|
      if x.match(Regexp.new(company)) != nil and x.match(/10-Q/) != nil
        company_url = x
      end
    end
    
    if company_url == ""
      raise "Company 10-Q cannot be found"
    end

    rescue
      return nil
    end
    return company_url
  end

  def parse_html_struct(parse_page)
    total_assets_array = []
    grabbed = false

    parse_page.each_with_index do |x,i|
      if x.match(/TOTAL ASSETS/) != nil
        parse_page[i,parse_page.length].each do |y|
          if y.match(/<\/tr>/) == nil
            total_assets_array << y
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

    our_value = total_assets_array[18].match(/[0-9\,]*<\/font>/).to_s.split('<')[0]

    our_value = "TotalAssets " + our_value
  end

  def scrape
    url = "https://www.sec.gov/Archives/edgar/full-index/"+year+"/QTR"+quarter+"/form.idx"
    parse_page = url_response_split(url)
    company_url = company_url_getter(parse_page)
    #need a more robust way to say can't find the form
    if company_url == nil
      return "TotalAssets 999"
    end

    search_url = 'https://www.sec.gov/Archives/' + company_url.match(/edgar\/[a-z\/0-9\-\.]*/).to_s
    parse_page = url_response_split(search_url)
    total_value = parse_html_struct(parse_page)

    return total_value 
  end
end

class StaticpagesController < ApplicationController

  def index
    @filings = Filing.all
  end

  def create
    #total_rev = scrapper_int_val
    Filing.create(name:"General Electric",ticker:"GE",year:2004,quarter:3)
    redirect_to root_path
  end

  private

  def scrapper_int_val
    val = Scrapper.new.scrape
    val = val.split(' ')[1].delete(',').to_i
  end
end

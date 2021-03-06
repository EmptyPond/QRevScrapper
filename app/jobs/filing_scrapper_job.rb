class FilingScrapperJob < ApplicationJob
  queue_as :default

  def perform(filing)
    val = Scrapper.new(year=filing[:year].to_s,quarter=filing[:quarter].to_s,company=filing[:name]).scrape
    if val == "TotalAssets 999"
      filing.update_attributes(ticker:"No form found")
    else
      val = val.split(' ')[1].delete(',').to_i
    end
    filing.update_attributes(total_rev:val)
    ActionCable.server.broadcast "filing_channel", update: filing
  end
end

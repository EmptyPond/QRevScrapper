class StaticpagesController < ApplicationController

  def index
    @filings = Filing.all
    @new_filing = Filing.new
  end

  def create
    Filing.create(filing_params)
    redirect_to root_path
  end

  private 

  def filing_params
    params.require(:filing).permit(:name,:year,:quarter)
  end
end

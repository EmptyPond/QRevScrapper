class StaticpagesController < ApplicationController

  def index
    @filings = Filing.all
  end

  def create
    Filing.create(name:"General Electric",ticker:"GE",year:2004,quarter:3)
    redirect_to root_path
  end
end

require 'rails_helper'

RSpec.describe StaticpagesController, type: :controller do
  describe "staticpages#index" do
    it "should let someone access the frontpage" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "should successfully access data in the table" do
      FactoryGirl.create(:filing)
      filing = Filing.last
      expect(filing.name).to eq("General Electric")
    end
  end

  describe "staticpages#create" do
    it "should allow me to post to create with predetermined data but also will run the scrapper (not job yet)" do
      post :create
      filing = Filing.last
      expect(filing.ticker).to eq("GE")
      expect(response).to redirect_to root_path
    end 
  end
end

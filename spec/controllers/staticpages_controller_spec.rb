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
end

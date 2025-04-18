require 'rails_helper'

RSpec.describe "Homepage", type: :request do
  it "shows the homepage" do
    get root_path
    expect(response.body).to include("Ask AI")
  end
end

#encoding: utf-8

require 'spec_helper'

describe 'Routes' do

  it 'Shoud routes to add (cyrillic)' do
    get URI.encode("/нечто/add")

    expect(request.params[:action]).to eq("add")
    expect(request.params[:tree]).to eq("нечто")
  end


  it 'Shoud routes to edit #2 (cyrillic)' do
    get URI.encode("/нечто/edit")

    expect(request.params[:action]).to eq("edit")
    expect(request.params[:tree]).to eq("нечто")
  end


  it "Should redirects wrong formatted requests to /404" do
    get "/--wrong_format--"

    expect(response).to redirect_to("/404")
  end

end

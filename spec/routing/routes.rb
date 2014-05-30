require 'spec_helper'


describe 'Routes' do

  context "Action add" do
    it 'Shoud routes to add' do
      expect(get("/add")).to route_to("pages#add")
    end

    it 'Shoud routes to add #2' do
      expect(get("/smth/add")).
        to route_to(controller: 'pages', action: 'add', tree: 'smth')
    end
  end


  context "Action edit" do
    it 'Shoud routes to edit' do
      expect(get("/smth/edit")).
        to route_to(controller: 'pages', action: 'edit', tree: 'smth')
    end
  end


  context "Action open" do
    it 'Root shoud routes to open' do
      expect(get("/")).to route_to("pages#open")
    end

    it 'Shoud routes to open' do
      expect(get("/smth")).
        to route_to(controller: 'pages', action: 'open', tree: 'smth')
    end
  end

end
#encoding: utf-8

require 'spec_helper'

describe 'Page' do

  before(:all) do
    Page.delete_all
  end


  context 'Save' do

    it "Should raise on long URIs" do
      expect { Page.create!(tree: 'a' * 2090) }.to raise_error(Page::TreeTooLarge)
    end

    it "Should save normal URIs" do
      Page.create!(tree: '1.2.3').should be_a_kind_of(Page)
    end

    it "Should save cyrillic URIs" do
      Page.create!(tree: 'привет.е_бург.111').should be
    end

    it "Should raise on empty URIs" do
      expect { Page.create!(tree: '') }.to raise_error
    end

  end

  context 'HTML converter' do

    it "Should generate simple html" do
      Page.new(source: "** hello ** \\\\ lol \\\\").send(:to_html).should eq("<b> hello </b> <i> lol </i>")
    end

  end

  context 'Stuff' do

    it "Should take right URI" do
      Page.new(tree: '1.2.3.4').uri.shoud eq("/1/2/3/4/")
    end

    it "Should take right name" do
      Page.new(tree: '1.2.3.4').name.shoud eq("4")
    end

  end

end

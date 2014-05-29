class Page < ActiveRecord::Base

  require 'pry'

  validates_presence_of :tree

  default_scope { order(:tree) }


  def self.add(name, parents)
    return nil unless is_name_valid?(name)
    
    page = if parents.empty?
      Page.new(tree: name)
    else
      raise Page::WrongRequest if Page.where("tree ~ '#{parents}.*'").empty?
      Page.new(tree: "#{parents}.#{name}")
    end

    page if page.save!
  rescue Page::WrongRequest
    raise $!
  rescue
    nil
  end


  def uri
    "/#{self.tree.split.join('/')}/"
  end


  private

  def self.is_name_valid?(name)
    !!(name =~ /\A[\p{Alnum}_]+\z/)
  end

end


class Page::WrongRequest < StandardError; end

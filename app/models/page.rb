class Page < ActiveRecord::Base

  require 'pry'

  validates_presence_of :tree

  default_scope { order(:tree) }


  def self.add(name, parents)
    return nil unless is_name_valid?(name)
    
    page = if parents.empty?
      Page.new(tree: name)
    else
      raise Page::BadRequest if Page.where("tree ~ '#{parents}.*'").empty?
      Page.new(tree: "#{parents}.#{name}")
    end

    page if page.save!
  rescue Page::BadRequest
    raise $!
  rescue
    nil
  end


  def uri
    "/#{tree_array.join('/')}/"
  end

  def name
    tree_array.last
  end

  def change_name(name)
    return nil unless Page.is_name_valid?(name)

    buf = tree_array
    buf[-1] = name
    self.tree = buf.join('.')

    self if self.save!
  rescue
    nil
  end


  private

  def self.is_name_valid?(name)
    !!(name =~ /\A[\p{Alnum}_]+\z/)
  end

  def tree_array
    self.tree.split('.')
  end

end


class Page::BadRequest < StandardError; end
class Page::NotFound < StandardError; end

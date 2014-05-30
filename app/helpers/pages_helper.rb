module PagesHelper

  # require 'pry'

  def format_name_row(tree)
    offset = tree.count('.')
    index = (offset == 0 ? 0 : tree.rindex('.') + 1)
    prefix = '- - ' * offset
    prefix + tree[index..-1]
  end

end

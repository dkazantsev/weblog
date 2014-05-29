class PagesConstraint
  TREE_REGEXP = (/^(\/[\p{Alnum}_]+)+$/u).freeze
end

class AddConstraint < PagesConstraint
  def matches?(request)
    path = URI.decode(request.path).mb_chars
    return false unless path[-4..-1] == '/add'
    !!(path[0...-4] =~ TREE_REGEXP)
  end
end

class EditConstraint < PagesConstraint
  def matches?(request)
    path = URI.decode(request.path).mb_chars
    return false unless path[-5..-1] == '/edit'
    !!(path[0...-5] =~ TREE_REGEXP)
  end
end

class OpenConstraint < PagesConstraint
  def matches?(request)
    !!(URI.decode(request.path).mb_chars =~ TREE_REGEXP)
  end
end


Weblog::Application.routes.draw do

  root to: 'pages#open'

  get '*tree/add' => 'pages#add', constraints: AddConstraint.new

  get '*tree/edit' => 'pages#edit', constraints: EditConstraint.new

  get '*tree' => 'pages#open', constraints: OpenConstraint.new

  get '*tree' => redirect('/404')

end

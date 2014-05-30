#encoding: utf-8

class Page < ActiveRecord::Base

  validates_presence_of :tree

  before_save do |page|
    # некоторые браузеры не поддерживают более 2083 символов в GET-запрсах
    raise Page::TreeTooLarge if page.tree.length > 2047
    # имя не может быть больше 255 символов
    raise Page::LevelNameTooLarge if page.tree.split('.').last.length > 255
    # делаем html из source, пишем в body
    page.body = page.to_html
  end

  default_scope { order(:tree) }


  def self.add(name, parents)
    return nil unless is_name_valid?(name)
    
    page = if parents.empty?
      Page.new(tree: name)
    else
      # иногда родителей может не быть: хакеры всякие...
      raise Page::BadRequest if Page.where("tree ~ '#{parents}.*'").empty?
      Page.new(tree: "#{parents}.#{name}")
    end

    page if page.save!
  rescue Page::BadRequest
    # не спрашивайте гугл что такое $!
    # серьёзно
    raise $!
  rescue Page::TreeTooLarge
    raise $!
  rescue
    nil
  end


  def uri
    # образуем uri path
    # я не соглсен с теми, кто считает что этому место - в хэлперах
    "/#{tree_array.join('/')}/"
  end

  def name
    # читаем имя; хранится в дереве
    tree_array.last
  end

  def change_name(name)
    # меняем имя через правку дерева
    return nil unless Page.is_name_valid?(name)

    buf = tree_array
    buf[-1] = name
    self.tree = buf.join('.')

    self if self.save!
  rescue Page::TreeTooLarge
    raise $!
  rescue
    nil
  end


  protected

  def to_html
    # Remember: one slash escapes other one.
    return nil unless self.source.present?
    
    text = self.source.dup

    text = loop_sub(text, /\*{2}/, '<b>', '</b>')
    text = loop_sub(text, /\\{2}/, '<i>', '</i>')
    text = smart_sub(text, /\({2}/, /\){2}/, "<a href=\"<target>\">", "</a>")

    text
  end


  private

  def self.is_name_valid?(name)
    !!(name =~ /\A[\p{Alnum}_]+\z/u)
  end

  def tree_array
    self.tree.split('.')
  end

  def loop_sub(text, regexp, open_tag, close_tag)
    # простая замена вхождений на html-теги

    position = 0

    loop do
      open = text.index(regexp, position)
      break unless open
      position = open

      text[open..open+1] = open_tag

      close = text.index(regexp, position)
      break unless close
      position = close

      text[close..close+1] = close_tag
    end

    text
  end

  def smart_sub(text, open_regexp, close_regexp, open_tag, close_tag)
    # специфичная замена вхождений на html-теги
    # ребята, извините, нормальный парсер - это не тема для тестового задания

    position = 0

    loop do
      open = text.index(open_regexp, position)
      break unless open
      position = open

      close = text.index(close_regexp, position)
      break unless close
      position = close

      target = text[open+2...close].strip

      buf = "#{open_tag}#{target}#{close_tag}"
      buf.sub!('<target>', target)

      text[open..close+1] = buf
    end

    text
  end

end

# классы ошибок; для удобства

class Page::BadRequest < StandardError; end
class Page::NotFound < StandardError; end
class Page::TreeTooLarge < StandardError; end
class Page::LevelNameTooLarge < StandardError; end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def facebox_attr
    "facebox[.wider]" if authorized?
  end

  def user_owned_tag
    builder = Builder::XmlMarkup.new
    builder.span(:class => "icon-marker") do |b|
      b.text('*')
    end
  end
  
  def separator_tag
    builder = Builder::XmlMarkup.new
    builder.span(:class => "icon-separator") do |b|
      b.text('|')
    end
  end

  def flash_tag(key = :notice)
    return '' if flash[key].blank?
    text = flash[key].sub(/(WARN|ERROR):/, '')
    key  = $1
    state, icon = case 
    when key =~ /WARN/
      [ :error, :alert ] 
    when key =~ /ERROR/
      [ :error, :alert] 
    else 
      [ :highlight, :info ]
    end
    builder = Builder::XmlMarkup.new
    builder.div(:class => "ui-state-#{state} ui-corner-all", :style => 'padding: 0.7em; margin-bottom: 1em') do |b|
      b.span(:class => "ui-icon ui-icon-#{icon}", :style => 'float: left; margin-right: 0.7em') { }
      b.text(text)
    end
  end
  
  def textualize(text, mode = :tags)
    text = html_escape(text)
    map  = { :'!' => 'strong', :'*' => 'em', :'`' => 'code' }
    unless mode == :notags
      text.gsub!(/\n/, '<br/>')
      text.gsub!(/(`|\*|!)(\w+)(`|\*|!)/) { code = map[$1.to_sym]; "<#{code}>#$2</#{code}>" }
      text.gsub!(/url\((.+)\)/ ) { "<code><a href=\"#$1\">#$1</a></code>" }
      text.gsub!(/&lt;code&gt;(.+)&lt;\/code&gt;/) { "<pre><code>#$1</code></pre>" }
    else
      text.gsub!(/&lt;code&gt;(.+)&lt;\/code&gt;/, '')
    end
    text
  end
  
  def truncate_words(text, length = 30, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length - 1)].join(' ') + (words.length > length ? end_string : '')
  end  
end

class FancyMarkup

  attr_accessor :indents, :html

  def initialize
    @indents = 0
    @html = ""
  end

  # Catch-all method to avoid creating methods
  # for each HTML element.
  def method_missing(m, *args, &block)
    tag(m, args, &block)
  end

  # The first method called when creating an
  # HTML document.
  def document(*args, &block)
    tag(:html, args, &block)
  end

  private

  # Create the HTML tag
  # @param (String|Symbol) HTML tag (ul, li, strong, etc...)
  # @param (Array) Can contain a String of text or a Hash of attributes
  # @param (Block) An optional block which will further nest HTML
  def tag(html_tag, args, &block)
    content = find_content(args)
    options = html_options(find_options(args))

    html << "\n#{indent}<#{html_tag}#{options}>#{content}"
    if block_given?
      @indents += 1
      instance_eval(&block)
      @indents -= 1
      html << "\n#{indent}"
    end
    html << "</#{html_tag}>"
  end

  # Searching the tag arguments, find the text/context element.
  def find_content(args)
    args.detect{|arg| arg.is_a? String}
  end

  # Searching the tag arguments, find the hash/attributes element
  def find_options(args)
    args.detect{|arg| arg.is_a? Hash} || {}
  end

  # Indent output number of spaces
  def indent
    "  " * indents
  end

  # Build html options string from Hash
  def html_options(options)
    options.collect{|key, value|
      value = value.to_s.gsub('"', '\"')
      " #{key}=\"#{value}\""
    }.join("")
  end
end

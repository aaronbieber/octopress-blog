module Jekyll
  class InfoBox < Liquid::Block
    require "kramdown"

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      output = Kramdown::Document.new(super).to_html
      "<div class=\"infobox\">#{output}</div>"
    end

    # Lifted from Blockquote (blockquote.rb) and slightly modified.
    def paragraphize(input)
      "#{input.lstrip.rstrip.gsub(/\n\n/, '</p><p>').gsub(/\n/, '')}"
    end
  end
end

Liquid::Template.register_tag('infobox', Jekyll::InfoBox)

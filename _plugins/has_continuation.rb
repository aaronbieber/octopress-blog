module Jekyll
  module ExcerptFilter
    def has_continuation(post)
      if @context.registers[:site].config.include? 'excerpt_separator'
        separator = @context.registers[:site].config['excerpt_separator']
        if post.fetch('excerpt').to_s.length != post.fetch('content').to_s.sub(separator, '').length
          return 'true'
        end
      end
      return 'false'
    end
  end
end

Liquid::Template.register_filter(Jekyll::ExcerptFilter)

module Remotipart
  # Responder used to automagically wrap any non-xml replies in a text-area
  # as expected by iframe-transport.
  module RenderOverrides
    include ERB::Util

    def self.included(base)
      if respond_to? :prepend
        base.prepend Prependable
      else
        base.include Includable
        # Do not use alias_method_chain for compatibility
        alias render_without_remotipart render
        alias render render_with_remotipart
      end
    end

    module Prependable
      def render(*args, &block)
        treat_render_for_remotipart super(*args, &block)
      end
    end

    module Includable
      def render_with_remotipart(*args, &block)
        treat_render_for_remotipart render_without_remotipart(*args, &block)
      end
    end

    def treat_render_for_remotipart(render_return_value)
      if remotipart_submitted?
        response_body
      else
        render_return_value
      end
    end
  end
end

module RspecApiDocumentation
  module Views
    class SlateIndex < MarkdownIndex
      def initialize(index, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_index"
        if configuration.slate_multiple_pages
          self.template_name = "rspec_api_documentation/slate_paged_index"
        end
      end
    end
  end
end

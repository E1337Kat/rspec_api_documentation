module RspecApiDocumentation
  module Views
    class SlatePagedIndex < MarkdownIndex
      def initialize(index, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_index"
      end
    end
  end
end

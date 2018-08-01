module RspecApiDocumentation
  module Views
    class SlatePagedData < MarkdownIndex
      def initialize(index, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_data"
      end
    end
  end
end

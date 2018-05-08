module RspecApiDocumentation
  module Views
    class SlatePagedHead < MarkdownIndex
      delegate :slate_multiple_pages, to: :@configuration, prefix: false
      def initialize(index, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_head"
      end
    end
  end
end

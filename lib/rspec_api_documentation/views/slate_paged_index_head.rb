module RspecApiDocumentation
  module Views
    class SlatePagedIndexHead < MarkdownIndex
      def initialize(index, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_index_head"
      end
    end
  end
end

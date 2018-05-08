module RspecApiDocumentation
  module Views
    class SlatePagedExampleHead < MarkdownExample
      def initialize(example, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_example_head"
      end
    end
  end
end

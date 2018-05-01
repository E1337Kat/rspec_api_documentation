module RspecApiDocumentation
  module Views
    class SlatePagedExample < MarkdownExample
      def initialize(example, configuration)
        super
        self.template_name = "rspec_api_documentation/slate_paged_example"
      end

      def parameters
        super.map do |parameter|
          parameter.merge({
                            :required => parameter[:required] == 'true' ? true : false,
                          })
        end
      end
    end
  end
end

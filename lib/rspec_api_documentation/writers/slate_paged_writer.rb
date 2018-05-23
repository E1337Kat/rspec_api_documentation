module RspecApiDocumentation
  module Writers
    class SlatePagedWriter < MarkdownWriter
      FILENAME = 'index.html.md'

      def self.clear_docs(docs_dir)
        FileUtils.mkdir_p(docs_dir)
        FileUtils.rm Dir[File.join docs_dir, "#{FILENAME}.*"]
      end

      def markup_index_class
        RspecApiDocumentation::Views::SlatePagedIndex
      end

      def markup_example_class
        RspecApiDocumentation::Views::SlatePagedExample
      end

      def markup_index_head_class
        RspecApiDocumentation::Views::SlatePagedIndexHead
      end

      def markup_example_head_class
        RspecApiDocumentation::Views::SlatePagedExampleHead
      end

      def markup_head_class
        RspecApiDocumentation::Views::SlatePagedHead
      end

      def write
        File.open(configuration.docs_dir
         .join("#{FILENAME}"), "w+") do |f|
          f.write markup_index_head_class.new(index, configuration).render
          f.write markup_head_class.new(index, configuration).render
          f.write markup_index_class.new(index, configuration).render
          IndexHelper.sections(index.examples, @configuration).each do |section|
            f.write "# #{section[:resource_name]}\n\n"
            f.write "#{section[:resource_explanation]}\n\n"
          end
        end
        write_example
      end

      def write_example
        index.examples.each do |example|
          markup_example = markup_example_class.new(example, configuration)
          FileUtils.mkdir_p(configuration.docs_dir.join(markup_example.resource_dir_name))

          File.open(configuration.docs_dir.join(markup_example.resource_dir_name, "#{FILENAME}"), "w+") do |f|
            f.write markup_example_head_class.new(example, configuration).render
            f.write markup_head_class.new(index, configuration).render
            IndexHelper.sections(index.examples, @configuration).each do |section|
              # file.write "# #{section[:resource_name]}\n\n"
              # file.write "#{section[:resource_explanation]}\n\n"
  
              section[:examples].each do |example|
                markup_example = markup_example_class.new(example, configuration)
                f.write markup_example.render
              end
            end
          end
        end
      end
      
    end
  end
end
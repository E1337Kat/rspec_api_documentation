module RspecApiDocumentation
  module Writers
    class SlatePagedWriter < MarkdownWriter
      FILENAME = 'index.html.md'.freeze
      DATAFILE = 'data.yml'.freeze

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

      def markup_data_class
        RspecApiDocumentation::Views::SlatePagedData
      end

      def write
        write_data_file
        write_index
        write_example
      end

      def write_data_file
        File.open(configuration.docs_dir.join(DATAFILE.to_s), 'w+') do |f|
          f.write markup_data_class.new(index, configuration).render #heck
        end
      end

      def write_index
        File.open(configuration.docs_dir.join(FILENAME.to_s), 'w+') do |f|
          f.write markup_index_class.new(index, configuration).render #doubleheck
          IndexHelper.sections(index.examples, @configuration).each do |section|
            f.write write_resource_name(section)
            if explantion_exists?(section)
              f.write aside_explanation(section)
            end
          end
        end
      end

      def write_example
        IndexHelper.sections(index.examples, @configuration).each do |section|
          FileUtils.mkdir_p(configuration.docs_dir.join(section[:dirname]))

          File.open(file_path(section), 'w+') do |f|
            f.write write_resource_name(section)
            f.write aside_explanation(section) if explantion_exists?(section)
          end

          section[:examples].each do |example|
            File.open(file_path(section), 'a+') do |f|
              markup_example = markup_example_class.new(example, configuration)
              f.write markup_example.render
            end
          end
        end
      end

      private

      def file_path(section)
        configuration.docs_dir.join(section[:dirname], FILENAME.to_s)
      end

      def write_resource_name(section)
        "# #{section[:resource_name]}\n\n"
      end

      def aside_explanation(section)
        aside = "<aside class=\"notice\">\n"
        aside += section[:resource_explanation].to_s
        aside += "\n</aside>\n\n"
        aside
      end

      def explantion_exists?(section)
        !section[:resource_explanation].blank?
      end
    end
  end
end

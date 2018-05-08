require 'mustache'

module RspecApiDocumentation
  module Views
    class MarkupIndex < Mustache
      attr_accessor :index, :configuration
      delegate :api_name, :slate_multiple_pages, :api_explanation, to: :@configuration, prefix: false
      SPECIAL_CHARS = /[<>:"\/\\|?*]/.freeze

      def initialize(index, configuration)
        @index = index
        @configuration = configuration
        self.template_path = configuration.template_path
      end

      def dirname
        index.examples.each do |example|
          sanitize(example.metadata[:resource_name])
        end
        # sections.each do |section|
        #   sanitize(section[:resource_name].to_s.downcase)
        # end
      end

      def filename
        index.examples.each do |example|
          sanitize(example.metadata[:description])
        end
        # sections.each do |section|
        #   sanitize(section[:description].to_s.downcase)
        # end
      end

      def linkname
        sections.each do |section|
          sanitize(section[:description].to_s.downcase)
        end
      end

      def sections
        RspecApiDocumentation::Writers::IndexHelper.sections(index.examples, configuration)
      end

      def sanitize(name)
        name.gsub(/\s+/, '_').gsub(SPECIAL_CHARS, '')
      end
    end
  end
end

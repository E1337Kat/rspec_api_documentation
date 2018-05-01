require 'mustache'

module RspecApiDocumentation
  module Views
    class MarkupIndex < Mustache
      delegate :api_name, :multiple_pages, :api_explanation, to: :@configuration, prefix: false

      def initialize(index, configuration)
        @index = index
        @configuration = configuration
        self.template_path = configuration.template_path
      end

      def dirname
        sanitize(sections[:resource_name].to_s.downcase)
      end

      def filename
        description = sections[:description]
        basename = sanitize(description.downcase)
        basename = Digest::MD5.new.update(description).to_s if basename.blank?
        "#{basename}.#{extension}"
      end

      def linkname
        sanitize(sections[:description].to_s.downcase)
      end

      def sanitize(name)
        name.gsub(/\s+/, '_').gsub(SPECIAL_CHARS, '')
      end

      def sections
        RspecApiDocumentation::Writers::IndexHelper.sections(examples, @configuration)
      end
    end
  end
end

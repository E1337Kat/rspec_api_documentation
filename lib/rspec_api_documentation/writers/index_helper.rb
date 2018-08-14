require "active_support/core_ext/enumerable"

module RspecApiDocumentation
  module Writers
    module IndexHelper
      SPECIAL_CHARS = /[<>:"\/\\|?*\']/.freeze
      def sections(examples, configuration)
        resources = examples.group_by(&:resource_name).inject([]) do |arr, (resource_name, examples)|
          ordered_examples = configuration.keep_source_order ? examples : examples.sort_by(&:description)
          arr.push(:resource_name => resource_name, :examples => ordered_examples, :dirname => sanitize(resource_name), resource_explanation: examples.first.resource_explanation)
        end
        configuration.keep_source_order ? resources : resources.sort_by { |resource| resource[:resource_name] }
      end

      def sanitize(name)
        name.gsub(/\s+/, '_').gsub(SPECIAL_CHARS, '').to_s.downcase
      end
      module_function :sections, :sanitize
    end
  end
end

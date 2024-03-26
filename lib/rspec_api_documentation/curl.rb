require 'active_support/core_ext/object/to_query'
require 'base64'

module RspecApiDocumentation
  class Curl < Struct.new(:method, :path, :data, :headers)
    attr_accessor :host

    def output(config_host, config_headers_to_filer = nil)
      self.host = config_host
      @config_headers_to_filer = Array(config_headers_to_filer)
      send(method.downcase)
    end

    def detailed_output(config_host, config_headers_to_filer = nil)
      self.host = config_host
      @config_headers_to_filer = Array(config_headers_to_filer)
      send("detailed_#{method.downcase}")
    end

    def post
      "curl \"#{url}\" #{post_data} -X POST #{headers}"
    end

    def detailed_post
      {
        command: "curl \"#{url}\"",
        body: "#{post_data}",
        x: "-X POST",
        headers: detailed_headers}
    end

    def get
      "curl -g \"#{url}#{get_data}\" -X GET #{headers}"
    end

    def detailed_get
      {
        command: "curl -g \"#{url}#{get_data}\"",
        x: "-X GET",
        headers: detailed_headers
      }
    end

    def head
      "curl \"#{url}#{get_data}\" -X HEAD #{headers}"
    end

    def detailed_head
      {
        command: "curl \"#{url}#{get_data}\"",
        x: "-X HEAD",
        headers: detailed_headers
      }
    end

    def put
      "curl \"#{url}\" #{post_data} -X PUT #{headers}"
    end

    def detailed_put
      {
        command: "curl \"#{url}\"",
        body: "#{post_data}",
        x: "-X PUT",
        headers: detailed_headers
      }
    end

    def delete
      "curl \"#{url}\" #{post_data} -X DELETE #{headers}"
    end

    def detailed_delete
      {
        command: "curl \"#{url}\"",
        body: "#{post_data}",
        x: "-X DELETE",
        headers: detailed_headers
      }
    end

    def patch
      "curl \"#{url}\" #{post_data} -X PATCH #{headers}"
    end

    def detailed_patch
      {
        command: "curl \"#{url}\"",
        body: "#{post_data}",
        x: "-X PATCH",
        headers: detailed_headers
      }
    end

    def url
      "#{host}#{path}"
    end

    def headers
      filter_headers(super).map do |k, v|
        "\\\n\t#{header(k, v)}"
      end.join(" ")
    end

    def detailed_headers
      filter_headers(headers).map do |k, v|
        header(k, v)
      end
    end

    def header(key, value)
      if k =~ /authorization/i && v =~ /^Basic/
        "-u #{format_auth_header(v)}"
      else
        "-H \"#{format_full_header(k, v)}\""
      end
    end

    def get_data
      "?#{data}" unless data.blank?
    end

    def post_data
      escaped_data = data.to_s.gsub("'", "\\u0027")
      "-d '#{escaped_data}'"
    end

    private

    def format_auth_header(value)
      ::Base64.decode64(value.split(' ', 2).last || '')
    end

    def format_header(header)
      header.gsub(/^HTTP_/, '').titleize.split.join("-")
    end

    def format_full_header(header, value)
      formatted_value = if value.is_a?(Numeric)
        value
      else
        value ? value.gsub(/"/, "\\\"") : ''
      end

      "#{format_header(header)}: #{formatted_value}"
    end

    def filter_headers(headers)
      if !@config_headers_to_filer.empty?
        headers.reject do |header|
          @config_headers_to_filer.map(&:downcase).include?(format_header(header).downcase)
        end
      else
        headers
      end
    end
  end
end

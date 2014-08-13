module Tinybucket
  module Api
    module Helper
      module ApiHelper
        private

        def pass_api_config(result)
          case result
          when Tinybucket::Models::Page
            result.map { |m| m.api_config = @config.dup }
          when Tinybucket::Models::BaseModel
            result.api_config = @config.dup
          end

          result
        end

        def urlencode(v, key)
          if v.blank? || (escaped = CGI.escape(v.to_s)).blank?
            msg = "Invalid #{key} parameter. (#{v})"
            fail ArgumentError, msg
          end

          escaped
        end

        def build_path(base_path, *components)
          components.reduce(base_path) do |path, component|
            part = if component.is_a?(Array)
                     urlencode(*component)
                   else
                     component.to_s
                   end
            path + '/' + part
          end
        rescue ArgumentError => e
          raise ArgumentError, "Failed to build request URL: #{e}"
        end
      end
    end
  end
end

module ApiAuth

  module RequestDrivers # :nodoc:

    class TyphoeusRequest # :nodoc:
      include ApiAuth::Helpers

      def initialize(request)
        @request = request
        @headers = fetch_headers
        true
      end

      def set_auth_header(header)
        @request.options[:headers].merge!({ "Authorization" => header })
        @headers = fetch_headers
        @request
      end

      def calculated_md5
        md5_base64digest(@request.options[:body] || '')
      end

      def populate_content_md5
        @request.options[:headers]["Content-MD5"] = calculated_md5
      end

      def md5_mismatch?
        calculated_md5 != content_md5
      end

      def fetch_headers
        @request.options[:headers]
      end

      def content_type
        value = find_header(%w(Content-Type CONTENT-TYPE CONTENT_TYPE HTTP_CONTENT_TYPE))
        value.nil? ? "" : value
      end

      def content_md5
        value = find_header(%w(Content-MD5))
        value.nil? ? "" : value
      end

      def request_uri
        @request.url
      end

      def set_date
        @request.options[:headers].merge!({ "Date" => Time.now.utc.httpdate })
      end

      def timestamp
        value = find_header(%w(Date HTTP_DATE))
        value.nil? ? "" : value
      end

      def authorization_header
        find_header %w(Authorization AUTHORIZATION HTTP_AUTHORIZATION)
      end

      private

        def find_header(keys)
          keys.map {|key| @headers[key] }.compact.first
        end



    end

  end

end

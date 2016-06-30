require 'net/http'

require 'exception_notification/idobata/version'

module ExceptionNotifier
  class IdobataNotifier
    attr_reader :url

    def initialize(options)
      @options = extract_global_options(options, :url, :skip_library_backtrace, :proxy)

      raise(ArgumentError, 'Endpoint must be specified') unless @url
    end

    def call(exception, options={})
      enviroments =
        if options[:env]
          request_option(ActionDispatch::Request.new(options[:env]))
        else
          # [TODO] - Add option specification route for non-web notification
          {'Timestamp' => Time.zone.now}
        end

      source = build_message(exception, enviroments)

      http_client.post_form URI.parse(url),  source: source, format: :html
    end

    private

    def http_client
      @proxy ? Net::HTTP.Proxy(*extract_proxy_settings(@proxy)) : Net::HTTP
    end

    def extract_proxy_settings(proxy)
      case proxy
      when String
        extract_proxy_settings(URI(proxy))
      when URI
        [proxy.host, proxy.port]
      when Hash
        proxy.values_at(:host, :port)
      else
        proxy
      end
    end

    def extract_global_options(options, *global_option_names)
      options.dup.tap do |opts|
        global_option_names.each {|name| instance_variable_set "@#{name}", opts.delete(name) }
      end
    end

    def request_option(request)
      {
        'URL'         => request.original_url,
        'HTTP Method' => request.method,
        'IP Address'  => request.remote_ip,
        'Paramters'   => request.filtered_parameters,
        'Timestamp'   => Time.zone.now
      }
    end

    def build_message(exception, enviroments)
      return <<-HTML
<span class='label label-danger'>#{exception.class.to_s}</span>
<b>#{CGI.escapeHTML(exception.message.inspect)}</b>

<h4>Backtrace:</h4>
<pre>#{format_backtrace(exception.backtrace).join("\n")}</pre>

<h4>Environments:</h4>
<table>
  <tbody>
    #{table_rows_from(@options.merge(enviroments))}
  </tbody>
</table>
      HTML
    end

    def table_rows_from(hash)
      hash.each_with_object('') { |(key, value), rows|
        rows << "<tr><th>#{key}</th><td>#{value}</td></tr>"
      }
    end

    def format_backtrace(trace)
      trace.map { |line|
        if from_bundler?(line)
          @skip_library_backtrace ? nil : line.sub(bundle_root, '[bundle]...')
        else
          line.sub(app_root, '[app]...')
        end
      }.compact
    end

    def from_bundler?(line)
      if bundle_root
        line.match(bundle_root)
      end
    end

    def bundle_root
      Bundler.bundle_path.to_s if defined?(Bundler)
    end

    def app_root
      Dir.pwd
    end

  end
end

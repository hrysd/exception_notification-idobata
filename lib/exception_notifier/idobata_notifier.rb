require 'exception_notification/idobata/version'
require 'rest-client'

module ExceptionNotifier
  class IdobataNotifier
    attr_reader :url

    def initialize(options)
      @url = options[:url]
    end

    def call(exception, options={})
      env = options[:env]

      request = ActionDispatch::Request.new(env)

      source = build_message(exception,
        'URL'         => request.original_url,
        'HTTP Method' => request.method,
        'IP Address'  => request.remote_ip,
        'Paramters'   => request.filtered_parameters,
        'Timestamp'   => Time.zone.now
      )

      RestClient.post @url, source: source, format: 'html'
    end

    private

    def build_message(exception, enviroments)
      return <<-HTML
<span class='label label-important'>#{exception.class.to_s}</span>
<b>#{CGI.escapeHTML(exception.message.inspect)}</b>

<h4>Backtrace:</h4>
<pre>#{format_backtrace(exception.backtrace).join("\n")}</pre>

<h4>Environments:</h4>
<table>
  <tbody>
    #{table_rows_from(enviroments)}
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
          line.sub(bundle_root, '[bundle]...')
        else
          line.sub(app_root, '[app]...')
        end
      }
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

require 'exception_notification/idobata/version'
require 'rest-client'

module ExceptionNotifier
  class IdobataNotifier
    def initialize(options)
      @default_options = options
    end

    def table_rows_from(hash)
      hash.each_with_object('') do |(key, value), rows|
        rows << "<tr><th>#{key}</th><td>#{value}</td></tr>"
      end
    end

    def format_backtrace(trace)
      trace.map do |line|
        if from_bundler?(line)
          line.sub(bundle_root, '[bundle]...')
        else
          line.sub(app_root, '[app]...')
        end
      end
    end

    def call(exception, options={})
      env = options[:env]
      url = @default_options.delete(:url)

      request = ActionDispatch::Request.new(env) unless env.nil?

      table = {
        'URL'         => request.original_url,
        'HTTP Method' => request.method,
        'IP Address'  => request.remote_ip,
        'Paramters'   => request.filtered_parameters,
        'Timestamp'   => Time.zone.now
      }

      source = <<-HTML.strip_heredoc
        <span class='label label-important'>#{exception.class.to_s}</span>
        <b>#{CGI.escapeHTML(exception.message.inspect)}</b>

        <h4>Backtrace:</h4>
        <pre>#{format_backtrace(exception.backtrace).join("\n")}</pre>

        <h4>Detail:</h4>
        <table>
          <tbody>
            #{table_rows_from(table)}
          </tbody>
        </table>
      HTML

      RestClient.post url, source: source, format: 'html'
    end

    private

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

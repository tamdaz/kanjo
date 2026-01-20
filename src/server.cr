require "db"
require "json"
require "athena"
require "crinja"
require "sqlite3"
require "colorize"
require "athena-dotenv"

require "./kanjo"

if File.exists? "./.env"
  Athena::Dotenv.load
end

ATH.configure({
  framework: {
    cors: {
      enabled:  true,
      defaults: {
        allow_credentials: false,
        allow_origin:      ["*"],
        allow_methods:     %w[GET POST PUT DELETE],
        allow_headers:     %w[Content-Type Content-Disposition],
        expose_headers:    %w[Content-Type Content-Disposition],
      },
    },
    file_uploads: {
      enabled:       true,
      max_file_size: 1024 * 1024 * 10,
    },
  },
})

Crinja.function(:kanjo_version) { Kanjo::VERSION }
Crinja.function(:crystal_version) { Crystal::VERSION }
Crinja.function(:athena_version) { ATH::VERSION }

LOGGER_COLORS = {
  Log::Severity::Error => :red,
  Log::Severity::Warn  => :yellow,
  Log::Severity::Info  => :blue,
  Log::Severity::Debug => :light_magenta,
}

# Format the log while the server is running.
formatter = Log::Formatter.new do |entry, io|
  upcased_severity = entry.severity.label.upcase.ljust(5)

  io << "[ " << upcased_severity.colorize(LOGGER_COLORS[entry.severity]) << " ]"
  io << ' ' << entry.source.ljust(16).colorize.mode(:bold)
  io << " : " << entry.message
  io << " - " << entry.data.to_s.colorize(:light_gray).mode(:dim)

  if exception = entry.exception
    puts exception.inspect_with_backtrace
  end
end

Log.setup(:debug, Log::IOBackend.new(formatter: formatter))

{% unless flag?(:test) %}
  # Start the Athena server.
  ATH.run
{% end %}

require "spec"
require "../src/server"
require "athena/spec"
require "athena-clock"

def send_form_data(&block : HTTP::FormData::Builder -> _) : String
  io = IO::Memory.new

  HTTP::FormData.build(io, "a4VF") do |builder|
    block.call(builder)
  end

  io.to_s
end

def form_data_header : HTTP::Headers
  HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=\"a4VF\""}
end

ASPEC.run_all

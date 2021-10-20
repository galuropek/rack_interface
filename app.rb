require_relative "time_formatter"

class App
  HEADERS = { "Content-Type" => "text/plain" }

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info =~ /time/
      prepare_time_response(request.query_string)
    else
      response(404, "Not found path \"#{request.path_info}\"!")
    end
  end

  private

  def prepare_time_response(query_string)
    time_formatter = TimeFormatter.new
    time_formatter.call(query_string)

    if time_formatter.success?
      response(200, time_formatter.time_string)
    else
      response(400, time_formatter.invalid_string)
    end
  end

  def response(code, body)
    Rack::Response.new(["#{body}\n"], code, HEADERS)
  end
end

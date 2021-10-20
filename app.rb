require_relative "time_formatter"

class App
  def call(env)
    request = Rack::Request.new(env)

    if request.path_info =~ /time/
      time_formatter = TimeFormatter.new(request.query_string)
      prepare_time_response(time_formatter)
    else
      response(404, "Not found path \"#{request.path_info}\"!")
    end
  end

  private

  def prepare_time_response(time_formatter)
    if time_formatter.success?
      response(200, time_formatter.time_string)
    elsif time_formatter.format_params_present?
      response(400, time_formatter.invalid_string)
    else
      response(400, time_formatter.no_format_params_string)
    end
  end

  def response(code, body)
    [code, headers, ["#{body}\n"]]
  end

  def headers
    { "Content-Type" => "text/plain" }
  end
end

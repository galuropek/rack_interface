require_relative 'time_formatter'

class App
  AVAILABLE_PARAMS = %w[year month day hour minute second].freeze

  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when /time/
      request_query = URI.decode_www_form(request.query_string).to_h
      format_params = request_query["format"]
      return response(404, "Not found format params!") unless format_params

      params = format_params.split(',').map(&:strip).map(&:downcase).uniq
      if (unknown_params = params - AVAILABLE_PARAMS).empty?
        response(200, TimeFormatter.new(params).time)
      else
        response(400, "Unknown time format #{unknown_params}!")
      end
    else
      response(404, "Not found path \"#{request.path_info}\"!")
    end
  end

  private

  def response(code, body)
    [code, headers, ["#{body}\n"]]
  end

  def headers
    { "Content-Type" => "text/plain" }
  end
end

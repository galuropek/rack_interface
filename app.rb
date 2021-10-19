require 'byebug'

class App
  AVAILABLE_PARAMS = %w[year month day hour minute second].freeze

  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when /time/
      request_query = URI.decode_www_form(request.query_string).to_h
      format_params = request_query["format"]
      return response404(request.path_info) unless format_params

      @current_time = Time.now
      code, body = parse_format_params(format_params)
      response(code, body)
    else
      response404(request.path_info)
    end
  end

  private

  def parse_format_params(format)
    params = format.split(',').map(&:strip).map(&:downcase).uniq

    if (unknown_params = params - AVAILABLE_PARAMS).empty?
      [200, prepare_correct_body(params)]
    else
      [400, "Unknown time format #{unknown_params}!"]
    end
  end

  def prepare_correct_body(params)
    params.map { |param| send("current_#{param}".to_sym) }.join('-')
  end

  def response404(path_info)
    response(404, "Not found path #{path_info}!")
  end

  def response(code, body)
    [code, headers, ["#{body}\n"]]
  end

  def headers
    { "Content-Type" => "text/plain" }
  end

  def current_year
    @current_time.year
  end

  def current_month
    @current_time.month
  end

  def current_day
    @current_time.day
  end

  def current_hour
    @current_time.hour
  end

  def current_minute
    @current_time.min
  end

  def current_second
    @current_time.sec
  end
end

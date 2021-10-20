class TimeFormatter
  TIME_FORMAT = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(query_string)
    @query_string = query_string
  end

  def time_string
    Time.now.strftime(time_params.map { |param| TIME_FORMAT[param] }.join('-'))
  end

  def invalid_string
    "Unknown time format #{unknown_params}!"
  end

  def no_format_params_string
    "Not found format params!"
  end

  def success?
    return false unless format_params_present?

    unknown_params.empty?
  end

  def format_params_present?
    format_params && !format_params.empty?
  end

  private

  def time_params
    @time_params ||= @format_params.split(',').map(&:strip).map(&:downcase).uniq
  end

  def format_params
    @format_params ||= URI.decode_www_form(@query_string).to_h["format"]
  end

  def unknown_params
    @unknown_params ||= time_params - TIME_FORMAT.keys
  end
end

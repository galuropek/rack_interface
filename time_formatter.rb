class TimeFormatter
  attr_reader :unknown_params, :time_params

  TIME_FORMAT = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def call(query_string)
    format_params = URI.decode_www_form(query_string).to_h['format'] || ''
    @time_params = format_params.split(',').map(&:strip).map(&:downcase).uniq
    @unknown_params = time_params - TIME_FORMAT.keys
  end

  def time_string
    Time.now.strftime(@time_params.map { |param| TIME_FORMAT[param] }.compact.join('-'))
  end

  def invalid_string
    @time_params.any? ? "Unknown time format #{@unknown_params}!" : "Not found format params!"
  end

  def success?
    @time_params.any? && @unknown_params.empty?
  end
end

class TimeFormatter
  TIME_FORMAT = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(params)
    @params = params
  end

  def time
    Time.now.strftime @params.map { |param| TIME_FORMAT[param] }.join('-')
  end
end

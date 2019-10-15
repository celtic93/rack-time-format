class TimeFormat

  def initialize(app)
    @app = app

    @available_formats = {
      year: Time.now.year,
      month: Time.now.month,
      day: Time.now.day,
      hour: Time.now.hour,
      minute: Time.now.min,
      second: Time.now.sec
    }
  end

  def call(env)
    @env = env
    @status, @headers, @body = @app.call(env)

    check_format unless @status == 404

    [@status, @headers, @body]
  end

  private

  def check_format
    @formats = Rack::Utils.parse_nested_query(@env['QUERY_STRING']).values.join.split(",")
    @unknown_formats = []

    @formats.each do |format|
      @unknown_formats << format unless @available_formats[format.to_sym]
    end

    if @unknown_formats.any?
      unknown_formats_response
    else
      time_format_response
    end
  end

  def unknown_formats_response
    @status = 400
    @body = ["Unknown time format #{@unknown_formats.inspect}"]
  end

  def time_format_response
    @time = []

    @formats.each do |format|
      @time << @available_formats[format.to_sym]
    end

    @body = [@time.join('-')]
  end
end

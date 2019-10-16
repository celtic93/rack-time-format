class TimeFormat

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    @status, @headers, @body = @app.call(env)

    check_path

    [@status, @headers, @body]
  end

  private

  def check_path
    if @env['REQUEST_PATH'] == '/time'
      check_format
    else
      @status = 404
    end
  end
  
  def check_format
    @formatter = TimeFormatter.new
    @formats = Rack::Utils.parse_nested_query(@env['QUERY_STRING']).values.join.split(",")
    @unknown_formats = []
    
    @formats.each do |format|
      @unknown_formats << format unless @formatter.available_formats[format.to_sym]
    end

    if @unknown_formats.any?
      @status = 400
    end

    @body = [@formatter.response(formats: @formats, unknown_formats: @unknown_formats)]
  end
end

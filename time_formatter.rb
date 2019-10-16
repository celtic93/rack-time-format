class TimeFormatter

  attr_reader :available_formats
  attr_accessor :unknown_formats

  def initialize
    @available_formats = {
      year: Time.now.year,
      month: Time.now.month,
      day: Time.now.day,
      hour: Time.now.hour,
      minute: Time.now.min,
      second: Time.now.sec
    }
  end

  def response(params={})
    if params[:unknown_formats].any?
      unknown_formats_response(params[:unknown_formats])
    else
      time_format_response(params[:formats])
    end
  end

  private

  def unknown_formats_response(unknown_formats)
    "Unknown time format #{unknown_formats.inspect}"
  end

  def time_format_response(formats)
    @time = []

    formats.each do |format|
      @time << @available_formats[format.to_sym]
    end

    @time.join('-')
  end
end

class TimeFormatter
  PERMIT_FORMATS = { year: '%Y',
                     month: '%m',
                     day: '%d',
                     hour: '%I',
                     minute: '%M',
                     second: '%S' }

  def initialize(params)
    @formats = params['format'].split(',')
    @unknown_formats = []
    @time = []
  end

  def check_permit
    @formats.each do |format|
      if PERMIT_FORMATS[format.to_sym]
        @time << PERMIT_FORMATS[format.to_sym]
      else
        @unknown_formats << format
      end
    end
  end

  def permitted?
    @unknown_formats.empty?
  end

  def success_message
    Time.now.strftime(@time.join('-'))
  end

  def error_message
    "Unknown time format(s): #{@unknown_formats}"
  end
end
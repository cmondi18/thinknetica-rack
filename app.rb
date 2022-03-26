class TimeApp
  @@status = 404
  @@headers = { 'Content-Type' => 'text/plain' }
  @@body = ["Not Found"]

  @@permit_formats = %w[year month day hour minute second]

  def call(env)
    req = Rack::Request.new(env)
    @@has_unknown = false

    if req.path == '/time'
      if req.params.key?('format')
        formats = req.params['format'].split(',')
        check_unknown(formats)
        set_format(formats) unless @@has_unknown
      end
    else
      @@status = 404
      @@headers = { 'Content-Type' => 'text/plain' }
      @@body = ["Not Found"]
    end
    [@@status, @@headers, @@body]
  end

  private

  def set_format(formats)
    time = []
    formats.each do |format|
      if format == 'minute'
        time.append(Time.now.send('min').to_s)
      elsif format == 'second'
        time.append(Time.now.send('sec').to_s)
      else
        time.append(Time.now.send(format).to_s)
      end
      @@status = 200
      @@body = ["#{time.join('-')}"]
    end
  end

  def check_unknown(formats)
    unknown_formats = []
    formats.each do |format|
      unless @@permit_formats.include?(format)
        unknown_formats.append(format)
      end
    end
    if unknown_formats.any?
      @@has_unknown = true
      @@status = 400
      @@body = ["Unknown time format #{unknown_formats}"]
    end
  end
end

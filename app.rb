class TimeApp
  PERMIT_FORMATS = %w[year month day hour minute second]

  def call(env)
    req = Rack::Request.new(env)
    create_response(req)
  end

  private

  def create_response(request)
    return response(404, 'Not Found') if request.path != '/time' || !request.params.key?('format')

    formats = request.params['format'].split(',')
    unknown_formats = []
    time = []

    formats.each do |format|
      if PERMIT_FORMATS.include?(format)
        if format == 'minute'
          time.append(Time.now.send('min').to_s)
        elsif format == 'second'
          time.append(Time.now.send('sec').to_s)
        else
          time.append(Time.now.send(format).to_s)
        end
      else
        unknown_formats.append(format)
      end
    end

    if unknown_formats.any?
      response(400, "Unknown time format(s): #{unknown_formats}")
    else
      response(200, "#{time.join('-')}")
    end
  end

  def response(status, body)
    res = Rack::Response.new
    res.status = status
    res.header['Content-Type'] = 'text/plain'
    res.write(body)
    res.finish
  end
end

require_relative 'time_formatter'

class TimeApp
  def call(env)
    req = Rack::Request.new(env)
    create_response(req)
  end

  private

  def create_response(request)
    return response(404, 'Not Found') if request.path != '/time' || !request.params.key?('format')

    formatter = TimeFormatter.new(request.params)
    formatter.check_permit

    if formatter.permitted?
      response(200, formatter.success_message)
    else
      response(400, formatter.error_message)
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

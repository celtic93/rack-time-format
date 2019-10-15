class App
  
  def call(env)
    @env = env
    [status, headers, body]
  end

  private

  def status
    if @env['REQUEST_PATH'] == '/time'
      200
    else
      404
    end
  end

  def headers
    {'Content-type' => 'text/plain'}
  end

  def body
    []
  end
end

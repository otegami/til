class App
  def call env
    puts 1
    status = 200
    headers = { "Content-type" => "text/plain" }
    body = ["sample"]
    [status, headers, body]
  end
end

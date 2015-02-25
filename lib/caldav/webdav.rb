require "net/https"
require "uri"
require "rexml/document"
require "fileutils"

class WebDAV
  # WebDAV protocol: RFC4918
  # see http://tools.ietf.org/html/rfc4918
  #
  def initialize(base_url, proxy_host = nil, proxy_port = nil)
    base_url = base_url + '/' unless base_url[base_url.length - 1].chr() == '/'
    uri = URI.parse(base_url)
    @http = Net::HTTP.new(uri.host, uri.port, proxy_host, proxy_port)
    @http.use_ssl = true if uri.scheme == "https"
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @added_headers = Hash::new
  end

  def set_basic_auth(user, password)
    @auth_user, @auth_password = user, password
    return self
  end

  def set_header(name, value)
    @added_headers[name] = value if name && value
  end

  # 8.1 PROPFIND
  def propfind(path, depth = 1, xml_body = nil)
    req = setup_request(Net::HTTP::Propfind, path)
    req['Depth'] = depth
    if xml_body
      req.content_type = 'application/xml; charset="utf-8"'
      req.content_length = xml_body.size
      req.body = xml_body
    end
    dump_sv_request(req)
    res = @http.request(req)
    check_status_code(res, 207) # Multi-Status
    return res
  end

  # 8.2 PROPPATCH
  def proppatch
    raise NotImplementedError
  end

  # 8.3 MKCOL
  def mkcol(path)
    req = setup_request(Net::HTTP::Mkcol, path)
    res = @http.request(req)
    check_status_code(res, 201) # Created
    return res
  end

  # 8.4 GET
  def get(path)
    req = setup_request(Net::HTTP::Get, path)
    dump_sv_request(req)
    res = @http.request(req)
    check_status_code(res, 200) # OK
    return res
  end

  # 8.4 HEAD
  def head(path)
    req = setup_request(Net::HTTP::Head, path)
    res = @http.request(req)
    check_status_code(res, 200) # OK
    return res
  end

  # 8.5 POST
  def post(content, dest_path)
    req = setup_request(Net::HTTP::Post, dest_path)
    req.content_length = content.size
    req.body = content
    dump_sv_request(req)
    res = @http.request(req)
    check_status_code(res, [201, 204]) # Created or No content
    return res
  end

  # 8.6 DELETE
  def delete(path)
    req = setup_request(Net::HTTP::Delete, path)
    res = @http.request(req)
    dump_sv_request(req)
    check_status_code(res, 204)
    return res
  end

# 8.7 PUT
  def put(content, dest_path)
    req = setup_request(Net::HTTP::Put, dest_path)
    req.content_length = content.size
    req.body = content
    dump_sv_request(req)
    res = @http.request(req)
    check_status_code(res, [201, 204]) # Created or No content
    return res
  end

  # 8.8 COPY
  def copy(src_path, dest_path)
    req = setup_request(Net::HTTP::Copy, src_path)
    req['Destination'] = dest_path
    res = @http.request(req)
    check_status_code(res, 204) # No Content
    return res
  end

  # 8.9 MOVE
  def move(src_path, dest_path)
    req = setup_request(Net::HTTP::Move, src_path)
    req['Destination'] = dest_path
    res = @http.request(req)
    check_status_code(res, 204) # No Content
    return res
  end

  # 8.10 LOCK
  def lock(path)
    raise NotImplementedError
  end

  # 8.11 UNLOCK
  def unlock(path)
    raise NotImplementedError
  end

  ##############################################################
  private
  def check_status_code(res, required_status)
    unless ([required_status].flatten.map{|c| c.to_s}).member?(res.code)
      header = "Invalid HttpResponse Code"
      # raise Exception.new("#{header}: #{res.code} #{res.message}")
    end
  end

  def setup_request(request, *args)
    req = request.new(*args)
    req.basic_auth @auth_user, @auth_password
    # XXX: should implement re-connection mechanism for Keep-Alive:
    # http://d.hatena.ne.jp/daftbeats/20080321/1206092975
    req["Connection"] = "Keep-Alive"
    if @added_headers
      @added_headers.each do |name,value|
        req[name] = value
      end
    end
    return req
  end

  def fetch(uri_str, limit = 10)
    raise StandardError, 'HTTP redirect too deep' if limit == 0
    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response['location'], limit - 1)
    else
      response.value
    end
  end

  # CalDAV Proxy to Calendar Server
  def dump_sv_request(req)
    log = "\n###PROXY_REQUEST " + Time.now.to_s + " ###\n"
    log += "REQUEST_HEADER\n"
    log += "REQUEST_METHOD:" + req.method.to_s + "\n"
    req.each do |name,values|
      log += name + ":"
      if values.class == String then
        log += values
      elsif values.class == Array then
        values.each do |value|
          log += log + value.to_s + ", "
        end
      end
      log += "\n"
    end
    log += "\nREQUEST_BODY\n"
    if req.body == nil
      log += "None\n"
    else
      log += req.body.gsub(">",">\n")
    end
    file = File.open("log/Proxy-Server.log","a")
    begin
      file.write(log)
    rescue Encoding::UndefinedConversionError
    end
    file.close
  end
end # class WebDAV

require 'webrick'
class MagicServer

  class << self

    attr_reader :port

    def serve html
      @port = rand(9999)+10000
      @server = WEBrick::HTTPServer.new Logger: WEBrick::Log.new("/dev/null"),
                                        AccessLog: [],
                                        :Port => @port
      @server.mount_proc '/' do |req, res|
        res.body = html
      end
      t=Thread.fork { @server.start }
      t.join(1)
    end

    def stop
      @server.stop
    end

    def is_running?
      @port
    end
  end


end
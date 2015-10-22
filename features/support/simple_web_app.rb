require 'webrick'
class SimpleWebApp

  class << self

    attr_reader :port, :user_agents

    def add_user_agent user_agent
      @user_agents=[] unless @user_agents
      @user_agents << user_agent
    end

    def serve failing_browser=nil
      @port = rand(9999)+10000
      @server = WEBrick::HTTPServer.new Logger: WEBrick::Log.new("/dev/null"),
                                        AccessLog: [],
                                        :Port => @port
      @server.mount_proc "/" do |req, res|
        user_agent = req.header['user-agent'][0]
        add_user_agent user_agent
        res.body = if failing_browser && user_agent.include?(failing_browser)
                     "<h1>FAIL</h1>"
                   else

                     "<h1>#{user_agent}</h1><h2>hello</h2>"
                   end
      end
      t=Thread.fork {@server.start }
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
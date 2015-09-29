require 'sinatra'


get '/' do
  puts env['HTTP_USER_AGENT']
  <<-HTML
  <h1>#{env['HTTP_USER_AGENT']}</h1>
  <form action="/what" method="POST">
        <input type="submit"/>
  </form>
  HTML

end

post '/what' do
  if env['HTTP_USER_AGENT'].include?('MSIE 10.0')
  "STRUNZ"
  else
  "CIAO BELLO"
  end

end
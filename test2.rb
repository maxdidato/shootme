require 'sinatra'


get '/' do
  '<h1>'+env['HTTP_USER_AGENT']+'</h1>'
end
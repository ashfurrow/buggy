$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bot/echo'
require 'web'

Thread.new do
  begin
    EchoBot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run EchoBot::Web

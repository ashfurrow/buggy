$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-buggybot'
require 'web'

Thread.new do
  begin
    SlackBuggybot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run SlackBuggybot::Web

require_relative "lib/toy_robot"
require "optparse"

OptionParser.new do |opts|
  opts.banner = <<-MSG
    Usage:   ruby toy-robot-runner.rb [space delimited commands]
    Example: ruby toy-robot-runner.rb PLACE 0,0,NORTH MOVE REPORT
  MSG
end.parse!

result = ToyRobot.new.execute(ARGV.join(" "))
p result if result

#!/usr/bin/ruby

require 'erb'

def process_erb(src, dest)
  _in = File.new(src, "r")
  _out = File.new(dest, "w")

  _erb = ERB.new(_in.readlines.join)
  _out.puts(_erb.result($BINDING = binding()))

  _in.close
  _out.close
end

if __FILE__ == $0
  process_erb(ARGV[0], ARGV[1])
end

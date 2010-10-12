
$:.unshift File.join(File.dirname(__FILE__), 'statistic')

require 'calc'
require 'sample'
require 'distribution'

include Statistic
include Calc

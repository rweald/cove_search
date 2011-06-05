require 'rubygems'
$: << File.expand_path(File.dirname(__FILE__) + "/lib/")
#require File.expand_path(File.join(__FILE__, '..',"lib", "server.rb"))

require 'server.rb'

run SearchServer

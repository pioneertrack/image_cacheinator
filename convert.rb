#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'cgi'

puts ARGV[0]

puts CGI.inspect

open(ARGV[1],'wb') do |file|
  file << open(CGI::unescape(ARGV[0])).read
end

`convert #{ARGV[1]} -resize '#{CGI::unescape(ARGV[2])}' #{ARGV[1]}`


#!/usr/bin/env ruby
# Copyright (c) 2008 Chris Horn http://chorn.com/
# See MIT-LICENSE.txt

require "dialable"

ARGV.each do |filename|
  File.open(filename).each do |line|
    line.gsub!(/"/,"")
    
    
    next if line =~ /^(\d{10})$/ or line =~ /^\d{3}-\d{3}-\d{4}$/

    begin
      d = Dialable::NANP.parse(line)
    rescue
      d = "XXX-XXX-XXXX"
    end

    puts "#{d} #{line}"
  end
end

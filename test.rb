#!/usr/bin/env ruby

require "phone"
require "pp"

ARGV.each do |filename|
  File.open(filename).each do |line|
    line.gsub!(/"/,"")
    
    
    next if line =~ /^(\d{10})$/ or line =~ /^\d{3}-\d{3}-\d{4}$/

    begin
      d = Phone::NANP.parse(line)
    rescue
      d = "XXX-XXX-XXXX"
    end

    puts "#{d} #{line}"
  end
end

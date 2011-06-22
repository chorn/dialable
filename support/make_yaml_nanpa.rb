#!/usr/bin/env ruby

require "csv"
require "fileutils"
require "yaml"

system('wget --quiet "http://nanpa.com/npa/AllNPAs.zip"')
system('unzip -qj AllNPAs.zip AllNPAs.mdb')
system('mdb-export AllNPAs.mdb "`mdb-tables -1 AllNPAs.mdb`" > AllNPAs.csv')

all = CSV.read("AllNPAs.csv")
h = all[0]

in_service = h.index("In Service?")
location   = h.index("Location")
country    = h.index("Country")
tz         = h.index("Time Zone")
npa        = h.index("NPA")

nanpa = { :created => Time.now }

all.each do |row|
  next unless row[in_service] == "Yes"
  areacode = row[npa].to_s.to_i
  nanpa[areacode] = {}
  nanpa[areacode][:country] = row[country].to_s if row[country].to_s.size > 0
  nanpa[areacode][:timezone] = row[tz].to_s if row[tz].to_s.size > 0
  nanpa[areacode][:location] = row[location].to_s if row[location].to_s.size > 0 and row[location].to_s !~ /NANP Area/i and row[location].to_s !~ /^#{row[country].to_s}$/i 
end

puts nanpa.to_yaml

FileUtils.rm ["AllNPAs.zip", "AllNPAs.mdb", "AllNPAs.csv"]


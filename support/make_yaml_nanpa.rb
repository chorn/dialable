#!/usr/bin/env ruby

require "csv"
require "fileutils"
require "yaml"

system('wget --quiet "http://nanpa.com/npa/AllNPAs.zip"')
system('unzip -qj AllNPAs.zip AllNPAs.mdb')
system('mdb-export AllNPAs.mdb "`mdb-tables -1 AllNPAs.mdb`" > AllNPAs.csv')

all = CSV.read("AllNPAs.csv")
h = all[0]

nanpa = { :created => Time.now }

all.each do |row|
  next unless row[h.index("In Service?")] == "Yes"
  areacode = row.values_at(h.index("NPA")).to_s.to_i
  nanpa[areacode] = {}
  nanpa[areacode][:location] = row.values_at(h.index("Location")).to_s if row.values_at(h.index("Location")).to_s.size > 0 and row.values_at(h.index("Location")).to_s.size =~ /NANP area/
  nanpa[areacode][:country] = row.values_at(h.index("Country")).to_s if row.values_at(h.index("Country")).to_s.size > 0
  nanpa[areacode][:timezone] = row.values_at(h.index("Time Zone")).to_s if row.values_at(h.index("Time Zone")).to_s.size > 0
end

puts nanpa.to_yaml

FileUtils.rm ["AllNPAs.zip", "AllNPAs.mdb", "AllNPAs.csv"]



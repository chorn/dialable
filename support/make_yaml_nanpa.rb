#!/usr/bin/env ruby

require 'csv'
require 'yaml'

# Headers from http://nanpa.com/area_codes/AreaCodeDatabaseDefinitions.xls
headers = [:npa, :type_of_code, :assignable, :explanation, :reserved, :assigned, :asgt_date, :use, :location, :country, :in_service, :in_svc_date, :status, :pl, :blank, :overlay, :overlay_complex, :parent, :service, :time_zone, :blank, :map, :is_npa_in_jeopardy, :is_relief_planning_in_progress, :home_npa_local_calls, :home_npa_toll_calls, :foreign_npa_local_calls, :foreign_npa_toll_calls, :perm_hnpa_local, :perm_hnpa_toll, :perm_fnpa_local, :dp_notes]

nanpa = { :created => Time.now }

curl = `curl -sL http://nanpa.com/nanp1/npa_report.csv`

CSV.parse(curl, :headers => headers) do |row|
  next unless row.fetch(:npa) =~ /\A\d+\Z/ && row.fetch(:in_service).to_s =~ /y/i

  country  = row.fetch(:country) { '' }

  timezone = row.fetch(:time_zone) { '' }.to_s.gsub(/[\(\)]/, '')

  location = row.fetch(:location) { '' }
  location = '' if location =~ /NANP Area/i || location =~ /\A#{country}\Z/i

  nanpa[row[:npa].to_i] = { :country => country, :timezone => timezone, :location => location }
end

puts nanpa.to_yaml


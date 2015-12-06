#!/usr/bin/env ruby

require 'csv'
require 'yaml'

# Headers from http://nanpa.com/area_codes/AreaCodeDatabaseDefinitions.xls
headers = [:npa, :type_of_code, :assignable, :explanation, :reserved, :assigned, :asgt_date, :use, :location, :country, :in_service, :in_svc_date, :status, :pl, :blank, :overlay, :overlay_complex, :parent, :service, :time_zone, :blank, :map, :is_npa_in_jeopardy, :is_relief_planning_in_progress, :home_npa_local_calls, :home_npa_toll_calls, :foreign_npa_local_calls, :foreign_npa_toll_calls, :perm_hnpa_local, :perm_hnpa_toll, :perm_fnpa_local, :dp_notes]

nanpa = { :created => Time.now }

curl = `curl -sL http://nanpa.com/nanp1/npa_report.csv`

CSV.parse(curl, :headers => headers) do |row|
  next unless row.fetch(:npa) =~ /\A\d+\Z/ && row.fetch(:in_service).to_s =~ /y/i
  npa = row[:npa].to_i
  country = row.fetch(:country)
  location = row.fetch(:location) { 'US' }
  location = 'US' if location =~ /NANP Area/i || location =~ /\A#{country}\Z/i

  raw_timezones = row.fetch(:time_zone) { '' }.to_s.gsub(/[\(\)]/, '')
  timezones = []
  if raw_timezones =~ /UTC([\+\-]\d+)/
    timezones << case Regexp.last_match(1).to_i
                 when 10
                   'Pacific/Guam'
                 when -10
                   'US/Hawaii'
                 when -9
                   'US/Alaska'
                 end
  elsif country && country.upcase == "CANADA"
    if raw_timezones.split(//).any?
      timezones << raw_timezones.split(//).collect do |timezone|
        case timezone
        when 'E'
          "Canada/Eastern"
        when 'C'
          "Canada/Central"
        when 'M'
          "Canada/Mountain"
        when 'P'
          "Canada/Pacific"
        when 'N'
          "Canada/Newfoundland"
        when 'A'
          "Canada/Atlantic"
        else
          'America/None'
        end
      end
    else
      timezones << case location
                   when 'ONTARIO'
                     "Canada/Eastern"
                   when 'MANITOBA'
                     "Canada/Central"
                   when 'QUEBEC'
                     "Canada/Eastern"
                   else
                     'America/None'
                   end
    end
  elsif country && country.upcase == "US"
    timezones << raw_timezones.split(//).collect do |timezone|
      case timezone
      when 'E'
        "US/Eastern"
      when 'C'
        "US/Central"
      when 'M'
        "US/Mountain"
      when 'P'
        "US/Pacific"
      else
        case location
        when 'USVI'
          "America/Virgin"
        when 'PUERTO RICO'
          "America/Puerto_Rico"
        when 'AS'
          nil
        else
          'America/None'
        end
      end
    end
  elsif country
    timezones << case country.upcase
                 when "BAHAMAS"
                   "America/Virgin"
                 when "BARBADOS"
                   "America/Barbados"
                 when "ANGUILLA"
                   "America/Anguilla"
                 when "ANTIGUA/BARBUDA"
                   "America/Antigua"
                 when "BERMUDA"
                   "Atlantic/Bermuda"
                 when "BRITISH VIRGIN ISLANDS"
                   "America/Virgin"
                 when "CAYMAN ISLANDS"
                   "America/Cayman"
                 when "GRENADA"
                   "America/Grenada"
                 when "TURKS & CAICOS ISLANDS"
                   "America/Virgin"
                 when "MONTSERRAT"
                   "America/Montserrat"
                 when "SINT MAARTEN"
                   "America/Virgin"
                 when "ST. LUCIA"
                   "America/St_Lucia"
                 when "DOMINICA"
                   "America/Dominica"
                 when "ST. VINCENT & GRENADINES"
                   "America/Virgin"
                 when "DOMINICAN REPUBLIC"
                   "America/Virgin"
                 when "TRINIDAD AND TOBAGO"
                   "America/Virgin"
                 when "ST. KITTS AND NEVIS"
                   "America/Virgin"
                 when "JAMAICA"
                   "America/Jamaica"
                 end
  end

  nanpa[npa] = { :country => country }
  nanpa[npa][:timezones] = timezones.flatten.compact if timezones && timezones.flatten.compact.size > 0
  nanpa[npa][:location] = location if location
end

puts nanpa.to_yaml


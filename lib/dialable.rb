# Copyright (c) 2008-2011 Chris Horn http://chorn.com/
# See MIT-LICENSE.txt

require "dialable/version"
require "yaml"
require "tzinfo"
require 'rubygems'

module Dialable
  class NANP

    ##
    # Raised if something other than a valid NANP is supplied
    class InvalidNANPError < StandardError
    end

    ##
    # ERC, Easily Recognizable Codes
    module ServiceCodes
      ERC = {
        211 => "Community Information and Referral Services",
        311 => "Non-Emergency Police and Other Governmental Services",
        411 => "Local Directory Assistance",
        511 => "Traffic and Transportation Information (US); Provision of Weather and Traveller Information Services (Canada)",
        611 => "Repair Service",
        711 => "Telecommunications Relay Service (TRS)",
        811 => "Access to One Call Services to Protect Pipeline and Utilities from Excavation Damage (US); Non-Urgent Health Teletriage Services (Canada)",
        911 => "Emergency"
      }
    end

    ##
    # Regexs to match valid phone numbers
    module Patterns
      VALID = [
        /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*[ex]+\D*(\d{1,5})\D*$/i,
        /^\D*1?\D*([2-9]\d\d)[ $\\\.-]*(\d{3})[ $\\\.-]*(\d{4})[ $\\\.\*-]*(\d{1,5})\D*$/i,
        /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D*$/,
        /^(\D*)(\d{3})\D*(\d{4})\D*$/,
        /^\D*([2-9]11)\D*$/,
        /^\D*1?\D*([2-9]\d\d)\D*(\d{3})\D*(\d{4})\D.*/  # Last ditch, just find a number
        ]
    end

    ##
    # Valid area codes per nanpa.com
    module AreaCodes
      data_path = Gem::datadir('dialable')
      data_path ||= File.join(File.dirname(__FILE__), '..', 'data', 'dialable')
      NANP = YAML.load_file(File.join(data_path, "nanpa.yaml"))
    end

    attr_accessor :areacode, :prefix, :line, :extension, :location, :country, :timezones, :relative_timezones, :raw_timezone

    def initialize(parts={})
      self.areacode  = parts[:areacode]  ? parts[:areacode]  : nil
      self.prefix    = parts[:prefix]    ? parts[:prefix]    : nil
      self.line      = parts[:line]      ? parts[:line]      : nil
      self.extension = parts[:extension] ? parts[:extension] : nil
    end

    def areacode=(raw_code)
      code = raw_code.to_i
      if AreaCodes::NANP[code]
        @areacode = raw_code
        self.location = AreaCodes::NANP[code][:location] if AreaCodes::NANP[code][:location]
        self.country = AreaCodes::NANP[code][:country] if AreaCodes::NANP[code][:country]
        self.raw_timezone = AreaCodes::NANP[code][:timezone] if AreaCodes::NANP[code][:timezone]

        if AreaCodes::NANP[code][:timezone]
          self.timezones = []
          self.relative_timezones = []
          tz = AreaCodes::NANP[code][:timezone]
          now = Time.now
          local_utc_offset = now.utc_offset/3600

          if tz =~ /UTC(-\d+)/
            self.timezones << tz
            utc_offset = $1.to_i
            self.relative_timezones << (utc_offset) - local_utc_offset
          else
            tz.split(//).each do |zone|  # http://www.timeanddate.com/library/abbreviations/timezones/na/
              zone = "HA" if zone == "H"
              zone = "AK" if zone == "K"
              tz = zone + (now.dst? ? "D" : "S") + "T"  # This is cludgey
              self.timezones << tz
              delta = nil
              if Time.zone_offset(tz)
                delta = Time.zone_offset(tz)/3600 - local_utc_offset
              else
                case zone
                when /N[SD]T/
                  delta = -3.5 - local_utc_offset
                when /A[SD]T/
                  delta = -4 - local_utc_offset
                when /A?K[SD]T/
                  delta = -9 - local_utc_offset
                when /HA?[SD]T/
                  delta = -10 - local_utc_offset
                end
                delta = delta - 1 if delta and now.dst?
              end
              # puts "#{delta} // #{Time.zone_offset(tz)} // #{tz} // #{local_utc_offset}"
              self.relative_timezones << delta if delta
            end
          end
        end
      else
        raise InvalidNANPError, "#{code} is not a valid NANP Area Code."
      end
    end

    def timezone
      @timezones.first if @timezones
    end

    def timezone=(tz)
      @timezones = [tz] if tz
    end

    # def relative_timezones
    #   rt = []
    #   @timezones.each do |tz|
    #     rt <<
    #   end
    #   rt
    # end

    def self.parse(number)
      Patterns::VALID.each do |pattern|
        return Dialable::NANP.new(:areacode => $1, :prefix => $2, :line => $3, :extension => $4) if number =~ pattern
      end

      raise InvalidNANPError, "Not a valid NANP Phone Number."
    end

    def erc?
      return ServiceCodes::ERC[@areacode].nil?
    end

    def to_s
      rtn = "#{@prefix}-#{@line}"
      rtn = "#{@areacode}-#{rtn}" if @areacode
      rtn = "#{rtn} x#{@extension}" if @extension
      rtn
    end

    def to_digits
      rtn = "#{@prefix}#{@line}"
      rtn = "#{@areacode}#{rtn}" if @areacode
      rtn = "#{rtn} x#{@extension}" if @extension
      rtn
    end

    def to_dialable
      rtn = "#{@prefix}#{@line}"
      rtn = "#{@areacode}#{rtn}" if @areacode
      rtn
    end

    def to_hash
      return {
        :areacode => @areacode,
        :prefix => @prefix,
        :line => @line,
        :extension => @extension
      }
    end
  end
end

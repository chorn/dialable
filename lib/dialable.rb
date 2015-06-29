require 'dialable/version'
require 'yaml'
require 'tzinfo'
require 'rubygems'
require 'dialable/service_codes'
require 'dialable/patterns'
require 'dialable/parsers'

module Dialable
  class NANP
    class InvalidNANPError < StandardError
    end

    # Valid area codes per nanpa.com
    module AreaCodes
      data_path = Gem.datadir('dialable')
      data_path ||= File.join(File.dirname(__FILE__), '..', 'data', 'dialable')
      NANP = YAML.load_file(File.join(data_path, 'nanpa.yaml'))
    end

    attr_accessor :areacode, :prefix, :line, :extension, :location, :country, :timezones, :relative_timezones, :raw_timezone
    attr_reader :service_codes, :patterns

    def self.parse(string, parser = Dialable::Parsers::NANP)
      parsed = parser.call(string)

      if parsed
        return Dialable::NANP.new(parsed)
      else
        fail InvalidNANPError, "Not a valid NANP Phone Number."
      end
    end

    def initialize(parts = {}, options = {})
      self.areacode  = parts.fetch(:areacode)
      self.prefix    = parts.fetch(:prefix)
      self.line      = parts.fetch(:line)
      self.extension = parts.fetch(:extension)
      @service_codes = options.fetch(:service_codes) { Dialable::ServiceCodes::NANP }
      @patterns      = options.fetch(:patterns)      { Dialable::Patterns::NANP }
    end

    def areacode=(raw_code)
      code = AreaCodes::NANP.fetch(raw_code.to_i) {
        fail InvalidNANPError, "#{code} is not a valid NANP Area Code."
      }

      @areacode = raw_code
      @location = code.fetch(:location) { nil }
      @country = code.fetch(:country) { nil }
      @raw_timezone = code.fetch(:timezone) { nil }
      @timezones = []
      @relative_timezones = []

      return unless @raw_timezone

      now = Time.now
      local_utc_offset = now.utc_offset / 3600

      if @raw_timezone =~ /UTC(-\d+)/
        utc_offset = Regexp.last_match(1).to_i
        @timezones << raw_timezone
        @relative_timezones << (utc_offset) - local_utc_offset
        return
      end

      # http://www.timeanddate.com/library/abbreviations/timezones/na/
      @raw_timezone.split(//).each do |zone|
        zone = 'HA' if zone == 'H'
        zone = 'AK' if zone == 'K'
        tz = zone + (now.dst? ? 'D' : 'S') + 'T'  # This is cludgey
        @timezones << tz

        delta = nil
        if Time.zone_offset(tz)
          delta = (Time.zone_offset(tz) / 3600) - local_utc_offset
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

          delta -= 1 if delta && now.dst?
        end

        @relative_timezones << delta if delta
      end
    end

    def timezone
      @timezones.first if @timezones
    end

    def timezone=(tz)
      @timezones = [tz] if tz
    end

    def relative_timezone
      @relative_timezones.first if @relative_timezones
    end

    def erc?
      @service_codes.has_key?(@areacode)
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
      {
        :areacode => @areacode,
        :prefix => @prefix,
        :line => @line,
        :extension => @extension
      }
    end
  end
end

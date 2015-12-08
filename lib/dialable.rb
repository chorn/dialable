require 'dialable/version'
require 'rubygems'
require 'tzinfo'
require 'dialable/area_codes'
require 'dialable/service_codes'
require 'dialable/patterns'
require 'dialable/parsers'

module Dialable
  class NANP
    class InvalidNANPError < StandardError; end

    attr_accessor :areacode, :prefix, :line, :extension, :location, :country, :timezones, :relative_timezones
    attr_reader :service_codes, :pattern

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
      code = AreaCodes::NANP.fetch(raw_code.to_i) { fail InvalidNANPError, "#{code} is not a valid NANP Area Code." }
      @areacode = raw_code
      @location = code.fetch(:location) { nil }
      @country = code.fetch(:country) { nil }
      @timezones = code.fetch(:timezones) { [] }
      @relative_timezones = @timezones.map { |timezone| timezone_offset(timezone) }
    end

    def erc?
      @service_codes.key?(@areacode)
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

    def timezone
      @timezones.first if @timezones
    end

    def timezone=(tz)
      @timezones = [tz] if tz
    end

    def raw_timezone
      @raw_timezones.first if @raw_timezones
    end

    def relative_timezone
      @relative_timezones.first if @relative_timezones
    end

    private

    def timezone_offset(raw)
      TZInfo::Timezone.get(raw).offsets_up_to(0).first.utc_total_offset / 3600
    end
  end
end

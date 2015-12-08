require 'dialable/patterns'

module Dialable
  module Parsers

    NANP = lambda do |string, patterns = Dialable::Patterns::NANP|
      patterns.each do |pattern|
        pattern.match(string) do |m|
          return { areacode: m[1],
                   prefix: m[2],
                   line: m[3],
                   extension: m[4],
                }
        end
      end
    end

  end
end

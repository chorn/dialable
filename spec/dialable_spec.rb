require 'spec_helper'

describe Dialable do
  context 'with a full NANP number with extension' do
    subject { Dialable::NANP.parse('+1(307)555-1212 ext 1234') }

    it 'will not raise an exception' do
    end

    it 'will parse the area code' do
      expect(subject.areacode).to eq '307'
    end

    it 'will parse the prefix' do
      expect(subject.prefix).to eq '555'
    end

    it 'will parse the line number' do
      expect(subject.line).to eq '1212'
    end

    it 'will parse the extension' do
      expect(subject.extension).to eq '1234'
    end
  end

  context 'with a full NANP number with extension and appropriate daylight/standard time' do
    let(:target_zone) { 'US/Mountain' }
    subject { Dialable::NANP.parse('+1(307)555-1212 ext 1234') }

    it 'will determine the time zone during daylight savings or standard time' do
      expect(subject.timezones).to eq [target_zone]
    end
  end

  NANP = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data', 'dialable') + '/nanpa.yaml')
  NANP.delete(:created)
  NANP.each do |nanp|
    areacode = nanp[0]
    country = nanp[1].fetch(:country) { nil }
    location = nanp[1].fetch(:location) { nil }
    timezones = nanp[1].fetch(:timezones) { nil }
    timezone = timezones.first if timezones

    context "with area code #{areacode}" do
      describe "when the areacode is in ()" do
        subject { Dialable::NANP.parse("(#{areacode})5551212") }

        it 'will parse the area code' do
          expect(subject.areacode).to eq areacode.to_s
        end
      end

      describe 'when there is text noise in the number' do
        subject { Dialable::NANP.parse("noise #{areacode}noise5551212") }

        it 'will parse area code' do
          expect(subject.areacode).to eq areacode.to_s
        end
      end

      describe 'when the areacode has extra noise' do
        subject { Dialable::NANP.parse("+1-#{areacode}555  1212") }

        it 'will find the location' do
          expect(subject.location).to eq location
        end
      end

      describe 'when the extension has extra noise' do
        subject { Dialable::NANP.parse("1 #{areacode} 867 5309 xAAA0001") }

        it 'will find the country' do
          expect(subject.country).to eq country
        end
      end

      describe 'when there is lots of garbage in the string' do
        subject { Dialable::NANP.parse("1 #{areacode}yadayada867BLAH5309....derp") }

        it 'will find the timezone' do
          expect(subject.timezone).to eq timezone
        end
      end
    end
  end
end

require File.dirname(__FILE__) + '/spec_helper'

describe Dialable do
  describe "with a full NANP number with extension" do
    subject { Dialable::NANP.parse("+1(307)555-1212 ext 1234") }

    it("should extract the area code") { subject.areacode.should == "307" }
    it("should extract the prefix") { subject.prefix.should == "555" }
    it("should extract the line number") { subject.line.should == "1212" }
    it("should extract the extension") { subject.extension.should == "1234" }

  end

  describe "with a full NANP number with extension and appropriate daylight/standard time" do
    subject { Dialable::NANP.parse("+1(307)555-1212 ext 1234") }
    it("should determine the time zone during daylight savings or standard time") {
      target_zone = Time.new.dst? ? "MDT" : "MST"
      subject.timezones.should == [target_zone]
    }
  end

  NANP = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data') + "/nanpa.yaml")
  NANP.delete(:created)
  NANP.each do |nanp|
    areacode = nanp[0]
    describe "recognize the area code #{areacode} in ()'s" do
      subject { Dialable::NANP.parse("(#{areacode})5551212") }
      it("should extract the area code") { subject.areacode.should == areacode.to_s }
    end
    describe "recognize the area code #{areacode} with garbage" do
      subject { Dialable::NANP.parse("noise #{areacode}noise5551212") }
      it("should extract the area code") { subject.areacode.should == areacode.to_s }
    end
    describe "with a sloppy areacode of #{areacode} and number" do
      subject { Dialable::NANP.parse("+1-#{areacode}555  1212") }
      it("should match the location") { subject.location.should == nanp[1][:location] }
    end
    describe "with areacode of #{areacode} and a sloppy extension" do
      subject { Dialable::NANP.parse("1 #{areacode} 867 5309 xAAA0001") }
      it("should match the country") { subject.country.should == nanp[1][:country] }
    end
    describe "with areacode of #{areacode} and lots of garbage" do
      subject { Dialable::NANP.parse("1 #{areacode}yadayada867BLAH5309....derp") }
      it("should match the timezone") { subject.raw_timezone.should == nanp[1][:timezone] }
    end
  end

end
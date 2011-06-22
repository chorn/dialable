require File.dirname(__FILE__) + '/spec_helper'

describe Dialable do
  describe "with a full NANP number with extension" do
    subject { Dialable::NANP.parse("+1(307)555-1212 ext 1234") }
    
    it("should extract the area code") { subject.areacode.should == "307" }
    it("should extract the prefix") { subject.prefix.should == "555" }
    it("should extract the line number") { subject.line.should == "1212" }
    it("should extract the extension") { subject.extension.should == "1234" }
    it("should determine the time zone") { subject.timezones.should == ["MDT"] }
  end

  describe "with pretty output" do
    subject { Dialable::NANP.parse("5858675309") }
    it("should extract the area code") { subject.areacode.should == "585" }
    it("should extract the prefix") { subject.prefix.should == "867" }
    it("should extract the line number") { subject.line.should == "5309" }
    it("should determine the time zone") { subject.timezones.should == ["EDT"] }
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
  end


end
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
end
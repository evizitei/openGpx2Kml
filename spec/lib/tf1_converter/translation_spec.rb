require 'timecop'
require_relative '../../../lib/tf1_converter'

module TF1Converter
  describe Translation do
    it "translates a file correctly" do
      execution_time = Time.local(2008, 9, 1, 12, 0, 0)
      Timecop.freeze(execution_time)
      local_dir = File.dirname(__FILE__)
      path = File.expand_path('../../fixtures', local_dir)
      input = File.open("#{path}/test.gpx", 'r')
      output = File.open("#{path}/test.kml", 'w')
      expected = File.open("#{path}/expected.kml", 'r')
      TF1Converter::Config.load(File.expand_path('../../../example/config.yml', local_dir))
      TF1Converter::Translation.from(input).into(output)

      result = File.open("#{path}/test.kml", 'r')
      result.read.should == expected.read
      Timecop.return
    end
  end
end

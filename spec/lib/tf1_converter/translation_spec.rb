require 'timecop'
require_relative '../../../lib/tf1_converter'

module TF1Converter
  describe Translation do
    before do
      execution_time = Time.local(2008, 9, 1, 12, 0, 0)
      Timecop.freeze(execution_time)
      Kml::TrackColor.uncache!
    end

    after do
      Timecop.return
    end

    let(:local_dir) { File.dirname(__FILE__) }
    let(:path) { File.expand_path('../../fixtures', local_dir) }
    let(:config_file) { File.expand_path('../../../example/config.csv', local_dir) }

    it "translates a file correctly" do
      input = File.open("#{path}/test.gpx", 'r')
      output = File.open("#{path}/test.kml", 'w')
      expected = File.open("#{path}/expected.kml", 'r')
      TF1Converter::Config.load(config_file)
      TF1Converter::Translation.from(input).into(output)

      result = File.open("#{path}/test.kml", 'r')
      result.read.should == expected.read
    end

    it 'translates a tracks-only file' do
      input = File.open("#{path}/ftwood2.gpx", 'r')
      output = File.open("#{path}/ftwood2.kml", 'w')
      TF1Converter::Config.load(config_file)
      #should not raise error
      TF1Converter::Translation.from(input).into(output)
    end

    it 'translates waypoints by name' do
      input = File.open("#{path}/waypoint-by-name.gpx", 'r')
      output = File.open("#{path}/waypoint-by-name.kml", 'w')
      TF1Converter::Config.load(config_file)
      TF1Converter::Translation.from(input).into(output)
      result = File.open("#{path}/waypoint-by-name.kml", 'r')
      result.read.should_not =~ /default\.png/
    end
  end

  describe 'file type checking' do
    it 'likes files with gpx endings' do
      TF1Converter::Translation.can_translate?("big-file.gpx").should be_true
    end

    it 'doesnt mind caps gpx' do
      TF1Converter::Translation.can_translate?("BIG-FILE.GPX").should be_true
    end

    it 'wont take files without gpx endings' do
      TF1Converter::Translation.can_translate?("big-file.kml").should be_false
    end

    it 'wont parse placeholder files' do
      TF1Converter::Translation.can_translate?(".").should be_false
      TF1Converter::Translation.can_translate?("..").should be_false
    end
  end
end

require_relative '../../../../lib/tf1_converter/config'
require_relative '../../../../lib/tf1_converter/kml/track_color'

module TF1Converter::Kml
  describe TrackColor do
    before(:each) do
      ::TF1Converter::Config.stub(:colors){ {'Blue'=>'1', 'Red'=>'2', 'Yellow'=>'3'}}
    end

    after(:each) do
      ::TF1Converter::Config.unstub!(:use_constant_color)
      ::TF1Converter::Config.unstub!(:colors)
    end

    it 'cycles colors when configured that way' do
      ::TF1Converter::Config.stub(:use_constant_color){ false }
      colors = [nil, nil].map{|n| TrackColor.next }
      colors[0].should_not == colors[1]
    end

    it 'generates a constant color when constant color switch flipped in config' do
      ::TF1Converter::Config.stub(:use_constant_color){ true }
      ::TF1Converter::Config.stub(:constant_color){ 'c12345' }
      colors = [nil, nil].map{|n| TrackColor.next }
      colors[0].should == colors[1]
      ::TF1Converter::Config.unstub!(:constant_color)
    end
  end
end

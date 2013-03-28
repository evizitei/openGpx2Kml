require_relative '../../../../lib/tf1_converter/config'
require_relative '../../../../lib/tf1_converter/kml/track_color'

module TF1Converter::Kml
  describe TrackColor do
    let(:colors) { [nil, nil].map{|n| TrackColor.next } }

    before(:each) do
      ::TF1Converter::Config.stub(:colors){ {'Blue'=>'1', 'Red'=>'2', 'Yellow'=>'3'}}
    end

    after(:each) do
      ::TF1Converter::Config.unstub!(:use_constant_color)
      ::TF1Converter::Config.unstub!(:colors)
    end

    describe 'no constant coloring' do
      before { ::TF1Converter::Config.stub(:use_constant_color){ false } }

      it 'cycles colors when configured that way' do
        colors[0].should_not == colors[1]
      end

      it 'left pads each color' do
        TrackColor.uncache!
        colors.each{ |v| v.should =~ /^0000000\d$/ }
      end
    end

    describe 'constant coloring' do

      before do
        ::TF1Converter::Config.stub(:use_constant_color){ true }
        ::TF1Converter::Config.stub(:constant_color){ 'c12345' }
      end

      it 'generates a constant color when constant color switch flipped in config' do
        colors[0].should == colors[1]
      end

      it 'left pads the color' do
        colors[0].should == '00c12345'
      end
    end

  end
end

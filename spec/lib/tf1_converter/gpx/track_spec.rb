require_relative '../../../../lib/tf1_converter/gpx/track'

module TF1Converter::Gpx
  describe Track do
    describe '#display_color' do
      it 'gets the mapped color name from the config' do
        color_map = {'Orange' => 'aabbccdd' }
        node = double(xpath: double(first: double(text: 'Orange')))
        track = Track.new(node, color_map)
        track.display_color.should == 'aabbccdd'
      end

      it 'returns a default color for nil' do
        node = double(xpath: double(first: nil))
        track = Track.new(node, {})
        track.display_color.should == 'f0000080'
      end
    end
  end
end

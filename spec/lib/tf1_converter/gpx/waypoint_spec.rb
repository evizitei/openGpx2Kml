require_relative '../../../../lib/tf1_converter/gpx/waypoint'

module TF1Converter::Gpx
  describe Waypoint do
    let(:icon_map) { {} }
    let(:node) { double }
    let(:waypoint) { Waypoint.new(node, icon_map) }

    describe '#icon_name' do
      it 'returns a matching name from the map' do
        node.stub_chain(:children, :select, :first, :text){ 'meaningoflife' }
        icon_map['meaningoflife'] = {'icon' => '42.png'}
        waypoint.icon_name.should == '42.png'
      end

      it 'returns a default value if there is no sym node' do
        node.stub_chain(:children, :select){ [] }
        waypoint.icon_name.should == 'default.png'
      end

      it 'gives a default value if there is no hash match' do
        node.stub_chain(:children, :select, :first, :text){ '' }
        waypoint.icon_name.should == 'default.png'
      end
    end

    describe '#icon_meaning' do
      it 'returns a matching meaning from the map' do
        node.stub_chain(:children, :select, :first, :text){ 'meaningoflife' }
        icon_map['meaningoflife'] = {'meaning' => 'life'}
        waypoint.icon_meaning.should == 'life'
      end

      it 'gives a default if no sym node' do
        node.stub_chain(:children, :select){ [] }
        waypoint.icon_meaning.should == 'Default'
      end

      it 'gives a default value if there is no hash match' do
        node.stub_chain(:children, :select, :first, :text){ '' }
        waypoint.icon_meaning.should == 'Default'
      end
    end
  end
end

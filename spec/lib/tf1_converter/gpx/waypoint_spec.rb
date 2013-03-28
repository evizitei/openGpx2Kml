require_relative '../../../../lib/tf1_converter/gpx/waypoint'
require 'nokogiri'

module TF1Converter::Gpx
  describe Waypoint do
    let(:icon_map) { {} }
    let(:node) { double }
    let(:waypoint) { Waypoint.new(node, icon_map) }


    let(:waypoint_by_name_fragment) do
      %Q{
        <wpt lat="38.9199972" lon="-92.2972443">
          <name>C05icon_name_42</name>
        </wpt>
      }
    end

    let(:default_fragment) do
      %Q{<wpt lat="38.9199972" lon="-92.2972443"></wpt>}
    end

    def waypoint_from(fragment)
      node = Nokogiri::XML.fragment(fragment).xpath('wpt').first
      Waypoint.new(node, icon_map)
    end

    describe '#icon_name' do
      it 'returns a matching name from the map' do
        node.stub_chain(:children, :select, :first, :text){ 'meaningoflife' }
        icon_map['meaningoflife'] = {'icon' => '42.png'}
        waypoint.icon_name.should == '42.png'
      end

      it 'can find a waypoint by name' do
        waypoint = waypoint_from(waypoint_by_name_fragment)
        icon_map['meaningoflife'] = { 'icon' => '42.png', 'name' => 'C05' }
        waypoint.icon_name.should == '42.png'
      end

      it 'can find a waypoint using an ampersand' do
        waypoint = waypoint_from(waypoint_by_name_fragment.gsub(/C05/,'&amp;05'))
        icon_map['meaningoflife'] = { 'icon' => '42.png', 'name' => '&05' }
        waypoint.icon_name.should == '42.png'
      end

      it 'returns a default value if there is no sym node' do
        waypoint = waypoint_from(default_fragment)
        waypoint.icon_name.should == 'default.png'
      end

      it 'gives a default value if there is no hash match' do
        node.stub_chain(:children, :select, :first, :text){ '' }
        node.stub_chain(:xpath, :first, :text){ '' }
        waypoint.icon_name.should == 'default.png'
      end

      it 'matches by name if there is no useful symbol match' do
        fragment = %Q{ <wpt lat="38.9199972" lon="-92.2972443">
          <sym>Non-sense</sym>
          <name>C05icon_name_42</name>
        </wpt> }
        waypoint = waypoint_from(fragment)
        icon_map['meaningoflife'] = { 'icon' => '42.png', 'name' => 'C05' }
        waypoint.icon_name.should == '42.png'
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

    describe '#timestamp' do

      it 'pulls from the cmt value first' do
        fragment = %Q{ <wpt> <cmt>Time1</cmt> <time>Time2</time> </wpt> }
        waypoint_from(fragment).timestamp.should == 'Time1'
      end

      it 'grabs the time element if there is no cmt' do
        fragment = %Q{ <wpt> <time>Time2</time> </wpt> }
        waypoint_from(fragment).timestamp.should == 'Time2'
      end

    end
  end
end

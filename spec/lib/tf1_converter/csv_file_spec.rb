require_relative '../../../lib/tf1_converter/csv_file'
require_relative '../../../lib/tf1_converter/gpx/waypoint'

module TF1Converter
  describe CsvFile do

    describe '#to_csv!' do
      let(:base_path){ '/some/long.path/with.file/test.gpx' }
      let(:csv) { [] }
 
      before do
        CSV.stub(:open).and_yield(csv)
      end

      it 'writes waypoints to the csv file' do
        waypoints = [double('waypoint').as_null_object]
        CsvFile.new(waypoints, base_path).to_csv!
        csv[1].first.should == '/some/long.path/with.file/test.csv'
      end

      it 'writes a blank string when theres no elevation' do
        waypoint = double('waypoint', elevation: Gpx::Waypoint::NoElevation).as_null_object
        waypoints = [waypoint]
        CsvFile.new(waypoints, base_path).to_csv!
        csv[1].last.should == ''
      end

      it "uses windows separators if the platform is windows" do
        ::TF1Converter::Config.stub(platform: 'WINDOWS')
        waypoints = [double('waypoint').as_null_object]
        CsvFile.new(waypoints, base_path).to_csv!
        csv[1].first.should == '\some\long.path\with.file\test.csv'
      end

    end

    describe '.translate_filename' do
      it 'changes a filepath to be a csv filename' do
        base_path = '/some/long/path/with/file'
        CsvFile.translate_filename("#{base_path}.kmz").should == "#{base_path}.csv"
      end

      it 'changes a filepath with dots to be a csv filename' do
        base_path = '/some/long.path/with.file'
        CsvFile.translate_filename("#{base_path}.kmz").should == "#{base_path}.csv"
      end
    end
  end
end

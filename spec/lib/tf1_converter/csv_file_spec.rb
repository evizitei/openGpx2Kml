require_relative '../../../lib/tf1_converter/csv_file'

module TF1Converter
  describe CsvFile do

    it 'writes waypoints to the csv file' do
      waypoints = [double('waypoint').as_null_object]
      base_path = '/some/long.path/with.file/test.gpx'
      csv = []
      CSV.stub(:open).and_yield(csv)
      CsvFile.new(waypoints, base_path).to_csv!
      csv[1].first.should == '/some/long.path/with.file/test'
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

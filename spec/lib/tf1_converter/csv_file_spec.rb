require_relative '../../../lib/tf1_converter/csv_file'

module TF1Converter
  describe CsvFile do
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

require_relative '../../../lib/tf1_converter/config'
require_relative '../../../lib/tf1_converter/kmz_file'

module TF1Converter
  describe KmzFile do
    describe '.full_filepath' do
      it 'paths correctly when config ends with slash' do
        TF1Converter::Config.stub(:icon_path){ '/some/path/'}
        KmzFile.full_filepath('filename').should == '/some/path/filename'
      end

      it 'paths correctly when config ends without slash' do
        TF1Converter::Config.stub(:icon_path){ '/some/path'}
        KmzFile.full_filepath('filename').should == '/some/path/filename'
      end
    end
  end
end
